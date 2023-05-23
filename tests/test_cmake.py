import re
import os
from pathlib import Path
import platform
import shutil
import subprocess

import pytest


def list_test_dirs():
    base_dir = Path(__file__).parent

    # Ignore directories that start with these characters
    exclude_start = [".", "_"]

    dirs = [d.name for d in base_dir.iterdir() if d.is_dir()]
    return [d for d in dirs if d[0] not in exclude_start]


@pytest.mark.parametrize("test_dir", list_test_dirs())
def test_cmake(test_dir):
    test_dir = Path(__file__).parent / test_dir

    apps = os.listdir(test_dir)

    if not any(app.startswith("app_") for app in apps):
        assert 0, f"No app found in {test_dir}"

    for app in apps:
        if app.startswith("app_"):
            app_dir = app  # Just take the first one for now

    build_dir = test_dir / app_dir / "build"
    bin_dir = test_dir / app_dir / "bin"

    # Pre-clean
    if bin_dir.exists() and bin_dir.is_dir():
        shutil.rmtree(bin_dir)
    if build_dir.exists() and build_dir.is_dir():
        shutil.rmtree(build_dir)

    # Set XMOS_CMAKE_PATH in local environment if not set
    cmake_env = os.environ
    if "XMOS_CMAKE_PATH" not in cmake_env:
        cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])

    # Run cmake; assumes that default generator is Ninja on Windows, otherwise Unix Makefiles
    ret = subprocess.run(
        ["cmake", "-B", "build", "."], cwd=test_dir / app_dir, env=cmake_env
    )
    assert ret.returncode == 0

    # Build
    build_tool = "ninja" if platform.system() == "Windows" else "make"
    ret = subprocess.run([build_tool], cwd=build_dir)
    assert ret.returncode == 0

    # Run all XEs
    # TODO we need to check that all the xe files we expect are present
    apps = bin_dir.glob("**/*.xe")
    for app in apps:
        print(app)
        run_expect = test_dir / f"{app.stem}.expect"

        ret = subprocess.run(["xsim", app], capture_output=True, text=True)
        assert ret.returncode == 0
        with open(run_expect, "r") as f:
            assert f.read() == ret.stdout

    # Cleanup
    shutil.rmtree(build_dir)
    shutil.rmtree(bin_dir)


def test_lib_export():
    test_dir = Path(__file__).parent / "lib_export" / "lib_foo" / "lib_foo"
    build_dir = test_dir / "build"
    lib_dir = test_dir / "lib"
    export_dir = test_dir / "export"

    # Pre-clean
    for d in [build_dir, lib_dir, export_dir]:
        if d.exists() and d.is_dir():
            shutil.rmtree(d)

    # Set XMOS_CMAKE_PATH in local environment if not set
    cmake_env = os.environ
    if "XMOS_CMAKE_PATH" not in cmake_env:
        cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])

    ret = subprocess.run(["cmake", "-B", "build", "."], cwd=test_dir, env=cmake_env)
    assert ret.returncode == 0

    build_tool = "ninja" if platform.system() == "Windows" else "make"
    ret = subprocess.run([build_tool], cwd=build_dir)

    assert lib_dir.exists() and lib_dir.is_dir()
    lib_arch_dir = lib_dir / "xs3a"
    assert lib_arch_dir.exists() and lib_arch_dir.is_dir()
    lib_a = lib_arch_dir / "liblib_foo.a"
    assert lib_a.exists()

    assert not export_dir.exists()
    ret = subprocess.run([build_tool, "export"], cwd=build_dir)
    assert ret.returncode == 0

    assert export_dir.exists() and export_dir.is_dir()
    export_lib_dir = export_dir / "lib"
    export_lib_files = [f.relative_to(export_dir) for f in export_lib_dir.glob("**/*")]
    expected_lib_files = [f.relative_to(test_dir) for f in lib_dir.glob("**/*")]
    assert all(f in export_lib_files for f in expected_lib_files)
    assert all(f in expected_lib_files for f in export_lib_files)

    export_source_dirs_re = r"EXPORT_SOURCE_DIRS\s+([\w\"\s]+)\)"
    export_dirs = []
    with open(test_dir / "CMakeLists.txt", "r") as f:
        for line in f.readlines():
            match = re.search(export_source_dirs_re, line)
            if not match:
                continue
            export_dirs = match.group(1).replace("\"", "").split(" ")
    assert len(export_dirs) != 0
    for d in export_dirs:
        export_d_dir = export_dir / d
        d_dir = test_dir / d
        assert export_d_dir.exists() and export_d_dir.is_dir()
        export_d_files = [f.relative_to(export_dir) for f in export_d_dir.glob("**/*")]
        expected_files = [f.relative_to(test_dir) for f in d_dir.glob("**/*")]
        assert all(f in export_d_files for f in expected_files)
        assert all(f in expected_files for f in export_d_files)

    # Cleanup
    for d in [build_dir, lib_dir, export_dir]:
        shutil.rmtree(d)
