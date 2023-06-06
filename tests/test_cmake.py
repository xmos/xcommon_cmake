import importlib.util
import os
from pathlib import Path
import platform
import shutil
import subprocess
import sys

import pytest


def list_test_dirs():
    base_dir = Path(__file__).parent

    # Ignore directories that start with these characters
    exclude_start = [".", "_"]

    dirs = [d.name for d in base_dir.iterdir() if d.is_dir()]
    return [d for d in dirs if d[0] not in exclude_start]


def cleanup_static_lib(lib_dir):
    build_dir = lib_dir / "build"
    if build_dir.exists() and build_dir.is_dir():
        shutil.rmtree(build_dir)

    bin_dir = lib_dir / lib_dir.name / "lib"
    if bin_dir.exists() and bin_dir.is_dir():
        shutil.rmtree(bin_dir)


def cleanup_app(app_dir):
    for d in ["build", "bin"]:
        dir = app_dir / d
        if dir.exists() and dir.is_dir():
            shutil.rmtree(dir)


def build(dir):
    # Set XMOS_CMAKE_PATH in local environment if not set
    cmake_env = os.environ
    if "XMOS_CMAKE_PATH" not in cmake_env:
        cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])

    # Run cmake; assumes that default generator is Ninja on Windows, otherwise Unix Makefiles
    ret = subprocess.run(["cmake", "-B", "build", "."], cwd=dir, env=cmake_env)
    assert ret.returncode == 0

    # Build
    build_tool = "ninja" if platform.system() == "Windows" else "make"
    ret = subprocess.run([build_tool], cwd=dir / "build")
    assert ret.returncode == 0


@pytest.mark.parametrize("test_dir", list_test_dirs())
def test_cmake(test_dir):
    test_dir = Path(__file__).parent / test_dir

    static_libs = []
    prebuild_file = test_dir / "prebuild.py"
    if prebuild_file.exists():
        prebuild_spec = importlib.util.spec_from_file_location(
            "module.name", prebuild_file
        )
        prebuild = importlib.util.module_from_spec(prebuild_spec)
        sys.modules["module.name"] = prebuild
        prebuild_spec.loader.exec_module(prebuild)

        for static_lib in prebuild.static_libs:
            static_libs.append(static_lib)
            cleanup_static_lib(test_dir / static_lib)
            build(test_dir / static_lib)

    apps = [
        d.name for d in test_dir.iterdir() if d.is_dir() and d.name.startswith("app_")
    ]

    if not len(apps):
        assert 0, f"No app found in {test_dir}"

    for app in apps:
        cleanup_app(test_dir / app)
        build(test_dir / app)

        bin_dir = test_dir / app / "bin"

        # Run all XEs
        # TODO we need to check that all the xe files we expect are present
        app_xes = bin_dir.glob("**/*.xe")
        for app_xe in app_xes:
            print(app_xe)
            run_expect = test_dir / f"{app_xe.stem}.expect"

            ret = subprocess.run(["xsim", app_xe], capture_output=True, text=True)
            assert ret.returncode == 0
            with open(run_expect, "r") as f:
                assert f.read() == ret.stdout

    # Cleanup
    for app in apps:
        cleanup_app(test_dir / app)
    for static_lib in static_libs:
        cleanup_static_lib(test_dir / static_lib)
