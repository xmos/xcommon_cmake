import importlib.util
import os
from pathlib import Path
import platform
import shutil
import stat
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

    bin_dir = lib_dir / "lib"
    if bin_dir.exists() and bin_dir.is_dir():
        shutil.rmtree(bin_dir)


def cleanup_app(app_dir):
    dot_build_dirs = [
        d.name for d in app_dir.iterdir() if d.is_dir() and d.name.startswith(".build")
    ]
    for d in ["build", "bin", *dot_build_dirs]:
        dir = app_dir / d
        if dir.exists() and dir.is_dir():
            shutil.rmtree(dir)


def build(dir, cmake, generator):
    cmake_env = os.environ
    cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])

    ret = subprocess.run(
        [cmake, "-G", generator.label, "-B", "build"],
        cwd=dir,
        env=cmake_env,
    )
    assert ret.returncode == 0

    ret = subprocess.run([generator.program], cwd=dir / "build")
    assert ret.returncode == 0


def run_xes(bin_dir, exp_dir):
    # TODO we need to check that all the xe files we expect are present
    app_xes = list(bin_dir.glob("**/*.xe"))

    # Always expect at least one application
    assert len(app_xes) > 0

    for app_xe in app_xes:
        run_expect = exp_dir / f"{app_xe.stem}.expect"

        ret = subprocess.run(["xsim", app_xe], capture_output=True, text=True)
        assert ret.returncode == 0
        with open(run_expect, "r") as f:
            assert f.read() == ret.stdout

        binary_expect = exp_dir / "binary.expect"
        if binary_expect.exists():
            ret = subprocess.run(
                ["xobjdump", "-t", app_xe], capture_output=True, text=True
            )
            with open(binary_expect, "r") as f:
                for l in f.readlines():
                    assert l in ret.stdout


@pytest.mark.parametrize("test_dir", list_test_dirs())
def test_cmake(cmake, generator, test_dir):
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
            build(test_dir / static_lib, cmake, generator)

    apps = [
        d.name for d in test_dir.iterdir() if d.is_dir() and d.name.startswith("app_")
    ]

    if not len(apps):
        assert 0, f"No app found in {test_dir}"

    for app in apps:
        cleanup_app(test_dir / app)
        build(test_dir / app, cmake, generator)

        bin_dir = test_dir / app / "bin"

        run_xes(bin_dir, test_dir)

    # Cleanup
    for app in apps:
        cleanup_app(test_dir / app)
    for static_lib in static_libs:
        cleanup_static_lib(test_dir / static_lib)


# When trying to remove git clones, there are read-only files which can't be immediately deleted
# on Windows. This function is called from an error by shutil.rmtree to change the permissions
# and remove the file.
def rmtree_error(func, path, exc_info):
    os.chmod(path, stat.S_IWRITE)
    os.remove(path)


# This test has extra cleanup to remove the cloned dependencies, so it is disabled from the
# parameterisation of test_cmake.
def test_fetch_deps(cmake, generator):
    test_dir = Path(__file__).parent / "_fetch_deps"
    dep_dirs = ["lib_dsp", "lib_logging", "lib_test_staticlib"]

    for dir in [test_dir / d for d in dep_dirs]:
        if dir.exists() and dir.is_dir():
            shutil.rmtree(dir, onerror=rmtree_error)

    test_cmake(cmake, generator, test_dir)

    for dir in [test_dir / d for d in dep_dirs]:
        if dir.exists() and dir.is_dir():
            shutil.rmtree(dir, onerror=rmtree_error)


def test_native_build(cmake, generator):
    test_dir = Path(__file__).parent / "_native_build"
    app_dir = test_dir / "app_native_build"
    build_dir = app_dir / "build"
    bin_dir = app_dir / "bin"
    lib_dir = test_dir / "lib_static0" / "lib_static0"
    lib_build_dir = lib_dir / "build"

    cleanup_app(app_dir)
    cleanup_static_lib(lib_dir)

    cmake_env = os.environ
    cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])

    cmake_native_cmd = [
        cmake,
        "-G",
        generator.label,
        "-B",
        "build",
        "-D",
        "BUILD_NATIVE=ON",
    ]

    ret = subprocess.run(cmake_native_cmd, cwd=lib_dir, env=cmake_env)
    assert ret.returncode == 0

    ret = subprocess.run([generator.program], cwd=lib_build_dir)
    assert ret.returncode == 0

    ret = subprocess.run(cmake_native_cmd, cwd=app_dir, env=cmake_env)
    assert ret.returncode == 0

    ret = subprocess.run([generator.program], cwd=build_dir)
    assert ret.returncode == 0

    exe_name = "native_build.exe" if platform.system() == "Windows" else "native_build"
    exe_path = Path(bin_dir) / exe_name
    ret = subprocess.run(
        [exe_path],
        capture_output=True,
        text=True,
        shell=True,
    )
    assert ret.returncode == 0
    with open(test_dir / "native_build.expect", "r") as f:
        assert f.read() == ret.stdout

    cleanup_app(app_dir)
    cleanup_static_lib(lib_dir)


def test_multi_app_build(cmake, generator):
    test_dir = Path(__file__).parent / "_multi_app_build"

    # First: test the build of both applications from the root directory
    app_dir = test_dir

    cleanup_dirs = [app_dir, app_dir / "app_foo", app_dir / "app_bar"]
    for dir in cleanup_dirs:
        cleanup_app(dir)

    build(app_dir, cmake, generator)

    bin_dirs = [app_dir / "app_foo" / "bin", app_dir / "app_bar" / "bin"]
    for bin_dir in bin_dirs:
        run_xes(bin_dir, test_dir)

    for dir in cleanup_dirs:
        cleanup_app(dir)

    # Second: test the builds from within the application directories
    test_cmake(cmake, generator, test_dir)
