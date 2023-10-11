import os
from pathlib import Path
import shutil
import subprocess

import pytest


def list_units():
    base_dir = Path(__file__).parent
    dirs = [d.name for d in base_dir.iterdir() if d.is_dir()]
    return [d for d in dirs if d.startswith("_unit_")]


@pytest.mark.parametrize("unit", list_units())
def test_unit(cmake, unit):
    test_dir = Path(__file__).parent / unit
    build_dir = test_dir / "build"

    # Remove any pre-existing build directory
    if build_dir.exists() and build_dir.is_dir():
        shutil.rmtree(build_dir)

    cmake_env = os.environ
    if "XMOS_CMAKE_PATH" not in cmake_env:
        cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])
    ret = subprocess.run(
        [cmake, "-G", "Unix Makefiles", "-B", "build"], cwd=test_dir, env=cmake_env
    )
    assert ret.returncode == 0

    # Cleanup
    if build_dir.exists() and build_dir.is_dir():
        shutil.rmtree(build_dir)
