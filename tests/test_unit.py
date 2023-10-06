import os
from pathlib import Path
import shutil
import subprocess

import pytest


def test_unit_parse_dep_string(cmake):
    test_dir = Path(__file__).parent / "_unit_parse_dep_string"
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
