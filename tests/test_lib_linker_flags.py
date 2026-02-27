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


def build(dir, cmake):
    cmake_env = os.environ
    cmake_env["XMOS_CMAKE_PATH"] = str(Path(__file__).parents[1])

    ret = subprocess.run(
        [cmake, "-G", "Unix Makefiles", "-B", "build"],
        cwd=dir,
        env=cmake_env,
        text=True, capture_output=True
    )
    assert ret.returncode == 0

    ret = subprocess.run(["xmake"], cwd=dir / "build", text=True, stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT)
    assert ret.returncode == 0
    return ret.stdout



# Test that LIB_LINKER_FLAGS are propagated to target_link_options of the app.
# It build the app and runs various checks to infer if the linker options were applied
# while linking the app.
def test_linker_flags(cmake):
    app_dir = Path(__file__).parent / "lib_linker_flags" / "app_lib_linker_flags"

    cleanup_app(app_dir)
    output = build(app_dir, cmake)

    failures = []

    # Check that linker option -report option in lib_mod1_1/lib_build_info.cmake gets propagated to the app
    if "Constraint check for tile[0]:" not in output:
        failures.append("ERROR: Linker option -report didn't get propagated to the app.")

    # Check that linker option -Wm,--map,test_linker_flags.map in lib_mod0/lib_build_info.cmake gets propagated to the app
    mapfile = app_dir / "build" / "test_linker_flags.map"
    if not mapfile.exists():
        failures.append("ERROR: Linker option -Wm,--map,test_linker_flags.map didn't get propagated to the app")

    # Check that linker option -v in lib_mod1/lib_build_info gets propagated to the app
    if ("xmap --defsymbol" not in output) and ("xmap.exe --defsymbol" not in output):
        failures.append("ERROR: Linker option -v didn't get propagated to the app.")

    joined_failures = "\n".join(failures)

    assert len(failures) == 0, (
        "Errors in test_linker_flags\n"
        f"{joined_failures}\n\n"
        "xmake output = \n"
        f"{output}\n"
    )
    # Cleanup
    cleanup_app(app_dir)