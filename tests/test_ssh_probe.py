import os
from pathlib import Path
import subprocess


# The SSH access check in parse_dep_string() treats an exit code of 1 as success (the code returned
# by ssh authenticating to github.com) and anything else as failure. These stubs stand in for ssh so
# that the tests are hermetic: "cmake -P" running a script which reaches message(FATAL_ERROR) exits
# with 1, and running an empty script exits with 0. Using cmake as the stub interpreter avoids
# platform-specific shell scripts.
def write_ssh_stub(stub_dir, cmake, exit_code):
    assert exit_code in (0, 1)
    script = stub_dir / f"ssh_stub_exit{exit_code}.cmake"
    if exit_code == 1:
        script.write_text('message(FATAL_ERROR "ssh stub reporting success")\n')
    else:
        script.write_text("# ssh stub reporting failure: exits 0\n")
    return f'"{Path(cmake).as_posix()}" -P "{script.as_posix()}"'


def write_probe_app(app_dir, dep="lib_abc"):
    app_dir.mkdir(parents=True)
    (app_dir / "src").mkdir()
    (app_dir / "src" / "main.c").write_text("int main(void) { return 0; }\n")
    (app_dir / "CMakeLists.txt").write_text(
        "\n".join(
            [
                "cmake_minimum_required(VERSION 3.21)",
                "include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)",
                "project(probe_app)",
                f'parse_dep_string("{dep}" ret_repo ret_ver ret_name)',
                'message(STATUS "PROBE_REPO=${ret_repo}")',
                "",
            ]
        )
    )


def configure(app_dir, cmake, ssh_command, extra_args=()):
    cmake_env = os.environ.copy()
    cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])
    cmake_env["GIT_SSH_COMMAND"] = ssh_command

    return subprocess.run(
        [cmake, "-G", "Unix Makefiles", "-B", "build", "-D", "BUILD_NATIVE=ON", *extra_args],
        cwd=app_dir,
        env=cmake_env,
        capture_output=True,
        text=True,
    )


def test_probe_uses_git_ssh_command_success(cmake, tmp_path):
    # A stub exiting 1 is read as SSH availability, so SSH URLs must be produced
    app_dir = tmp_path / "app_probe"
    write_probe_app(app_dir)
    stub = write_ssh_stub(tmp_path, cmake, exit_code=1)

    ret = configure(app_dir, cmake, stub)

    assert ret.returncode == 0, ret.stdout + ret.stderr
    assert "PROBE_REPO=git@github.com:xmos/lib_abc" in ret.stdout


def test_probe_uses_git_ssh_command_failure(cmake, tmp_path):
    # A stub exiting 0 is read as SSH being unavailable, so the probe must fall back to HTTPS and
    # announce the downgrade at the default log level
    app_dir = tmp_path / "app_probe"
    write_probe_app(app_dir)
    stub = write_ssh_stub(tmp_path, cmake, exit_code=0)

    ret = configure(app_dir, cmake, stub)

    assert ret.returncode == 0, ret.stdout + ret.stderr
    assert "PROBE_REPO=https://github.com/xmos/lib_abc" in ret.stdout
    assert "SSH access to github.com unavailable" in ret.stdout


def test_deps_protocol_https_skips_probe(cmake, tmp_path):
    # With the protocol forced, the stub would poison the result if the probe ran: it reports SSH
    # available, so an SSH URL would be produced. An HTTPS URL proves no probe happened.
    app_dir = tmp_path / "app_probe"
    write_probe_app(app_dir)
    stub = write_ssh_stub(tmp_path, cmake, exit_code=1)

    ret = configure(app_dir, cmake, stub, extra_args=("-D", "DEPS_PROTOCOL=https"))

    assert ret.returncode == 0, ret.stdout + ret.stderr
    assert "PROBE_REPO=https://github.com/xmos/lib_abc" in ret.stdout
    assert "SSH access to" not in ret.stdout


def test_deps_protocol_ssh_skips_probe(cmake, tmp_path):
    # Inverse of the https case: the stub reports SSH unavailable, so an SSH URL proves no probe
    app_dir = tmp_path / "app_probe"
    write_probe_app(app_dir)
    stub = write_ssh_stub(tmp_path, cmake, exit_code=0)

    ret = configure(app_dir, cmake, stub, extra_args=("-D", "DEPS_PROTOCOL=ssh"))

    assert ret.returncode == 0, ret.stdout + ret.stderr
    assert "PROBE_REPO=git@github.com:xmos/lib_abc" in ret.stdout
    assert "SSH access to" not in ret.stdout


def test_deps_protocol_invalid_fails(cmake, tmp_path):
    app_dir = tmp_path / "app_probe"
    write_probe_app(app_dir)
    stub = write_ssh_stub(tmp_path, cmake, exit_code=1)

    ret = configure(app_dir, cmake, stub, extra_args=("-D", "DEPS_PROTOCOL=carrier-pigeon"))

    assert ret.returncode != 0
    assert "Invalid DEPS_PROTOCOL" in ret.stdout + ret.stderr


def test_no_ssh_input_file_left_in_build_dir(cmake, tmp_path):
    # The previous implementation created an ssh-in.tmp file in the build directory on Windows to
    # suppress ssh prompts; BatchMode has replaced it, so nothing may be left behind on any platform
    app_dir = tmp_path / "app_probe"
    write_probe_app(app_dir)
    stub = write_ssh_stub(tmp_path, cmake, exit_code=1)

    ret = configure(app_dir, cmake, stub)

    assert ret.returncode == 0, ret.stdout + ret.stderr
    assert not (app_dir / "build" / "ssh-in.tmp").exists()
