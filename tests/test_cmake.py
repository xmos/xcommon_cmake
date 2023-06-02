import importlib.util
import os
from pathlib import Path
import platform
import shutil
import subprocess
import sys

import pytest


install_dir_name = "precompiled"


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

    install_dir = lib_dir.parent / install_dir_name
    if install_dir.exists() and install_dir.is_dir():
        shutil.rmtree(install_dir)


def install_static_lib(lib_dir):
    cleanup_static_lib(lib_dir)

    cmake_env = os.environ
    if "XMOS_CMAKE_PATH" not in cmake_env:
        cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])

    ret = subprocess.run(["cmake", "-B", "build", "."], cwd=lib_dir, env=cmake_env)
    assert ret.returncode == 0

    build_tool = "ninja" if platform.system() == "Windows" else "make"
    build_dir = lib_dir / "build"
    ret = subprocess.run([build_tool, "install"], cwd=build_dir)
    assert ret.returncode == 0


@pytest.mark.parametrize("test_dir", list_test_dirs())
def test_cmake(test_dir):
    test_dir = Path(__file__).parent / test_dir

    prebuild_file = test_dir / "prebuild.py"
    if prebuild_file.exists():
        prebuild_spec = importlib.util.spec_from_file_location(
            "module.name", prebuild_file
        )
        prebuild = importlib.util.module_from_spec(prebuild_spec)
        sys.modules["module.name"] = prebuild
        prebuild_spec.loader.exec_module(prebuild)
        static_libs = prebuild.static_libs

        for static_lib in static_libs:
            install_static_lib(test_dir / static_lib)
    else:
        static_libs = []

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
    for static_lib in static_libs:
        cleanup_static_lib(test_dir / static_lib)
