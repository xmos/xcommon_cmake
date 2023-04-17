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
    build_dir = test_dir / "build"
    bin_dir = test_dir / "bin"

    # Set XMOS_CMAKE_PATH in local environment if not set
    cmake_env = os.environ
    if "XMOS_CMAKE_PATH" not in cmake_env:
        cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])

    # Run cmake; assumes that default generator is Ninja on Windows, otherwise Unix Makefiles
    ret = subprocess.run(["cmake", "-B", "build", "."], cwd=test_dir, env=cmake_env)
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
