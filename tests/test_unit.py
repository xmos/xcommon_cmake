import os
from pathlib import Path
import shutil
import subprocess

import pytest


def list_units():
    base_dir = Path(__file__).parent
    dirs = [d.name for d in base_dir.iterdir() if d.is_dir()]
    return [d for d in dirs if d.startswith("_unit_")]


# The parse_dep_string unit test asserts SSH URL forms for github-style hosts and HTTPS fallback
# for the unreachable "othergitserver" hosts, so its expectations depend on the SSH access check.
# Point the check at a stub which reports success (ssh exit code 1) for every host except those
# containing "othergitserver", making the test hermetic instead of relying on the agent having
# real SSH access to github.com. "cmake -P" is used as the stub interpreter to stay portable: a
# script reaching message(FATAL_ERROR) exits 1, a plain return exits 0.
def ssh_stub_command(stub_dir, cmake):
    script = stub_dir / "ssh_stub.cmake"
    script.write_text(
        "\n".join(
            [
                'set(args "")',
                "foreach(i RANGE ${CMAKE_ARGC})",
                '    string(APPEND args " ${CMAKE_ARGV${i}}")',
                "endforeach()",
                'string(TOLOWER "${args}" args)',
                'if(NOT args MATCHES "othergitserver")',
                '    message(FATAL_ERROR "ssh stub reporting success")',
                "endif()",
                "",
            ]
        )
    )
    return f'"{Path(cmake).as_posix()}" -P "{script.as_posix()}"'


@pytest.mark.parametrize("unit", list_units())
def test_unit(cmake, unit, tmp_path):
    test_dir = Path(__file__).parent / unit
    build_dir = test_dir / "build"

    # Remove any pre-existing build directory
    if build_dir.exists() and build_dir.is_dir():
        shutil.rmtree(build_dir)

    cmake_env = os.environ.copy()
    cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])
    if unit == "_unit_parse_dep_string":
        cmake_env["GIT_SSH_COMMAND"] = ssh_stub_command(tmp_path, cmake)
    ret = subprocess.run(
        [cmake, "-G", "Unix Makefiles", "-B", "build"], cwd=test_dir, env=cmake_env
    )
    assert ret.returncode == 0

    # Cleanup
    if build_dir.exists() and build_dir.is_dir():
        shutil.rmtree(build_dir)
