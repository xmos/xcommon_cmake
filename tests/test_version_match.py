import os
from pathlib import Path
import re
import shutil
import subprocess

import yaml


def cleanup_app(app_dir):
    dot_build_dirs = [
        d.name for d in app_dir.iterdir() if d.is_dir() and d.name.startswith(".build")
    ]
    for d in ["build", "bin", *dot_build_dirs]:
        dir = app_dir / d
        if dir.exists() and dir.is_dir():
            shutil.rmtree(dir)


def cmake_verbose(dir, cmake, generator):
    cmake_env = os.environ
    cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])

    ret = subprocess.run(
        [cmake, "-G", generator.label, "-B", "build", "--log-level=VERBOSE"],
        cwd=dir,
        env=cmake_env,
        text=True,
        capture_output=True,
    )
    assert ret.returncode == 0

    return ret.stdout


# Perform CMake configuration on a dummy application with verbose logging to get the
# current version number, and then compare this with the version number in settings.yml
def test_version_match(cmake, generator):
    app_dir = Path(__file__).parent / "_version_match" / "app_version_match"

    cleanup_app(app_dir)
    output = cmake_verbose(app_dir, cmake, generator)

    version_re = r"^-- XCommon CMake version v([0-9]+\.[0-9]+\.[0-9]+)$"
    match = re.search(version_re, output, flags=re.MULTILINE | re.DOTALL)
    assert match
    xcommon_cmake_ver = match.group(1)

    settings_yml_file = Path(__file__).parents[1] / "settings.yml"
    with open(settings_yml_file, "r") as f:
        settings_yml = yaml.safe_load(f)

    settings_ver = settings_yml["version"]

    assert xcommon_cmake_ver == settings_ver

    # Cleanup
    cleanup_app(app_dir)
