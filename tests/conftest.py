from pathlib import Path
import os
import platform

import pytest


# If a virtual environment is active and contains cmake, use that one,
# otherwise just run "cmake" and expect it to be on the search path.
@pytest.fixture
def cmake():
    venv_path = os.environ.get("VIRTUAL_ENV", None)
    if venv_path:
        if platform.system() == "Windows":
            cmake_path = Path(venv_path) / "Scripts" / "cmake.exe"
            if cmake_path.exists():
                return cmake_path
        else:
            cmake_path = Path(venv_path) / "bin" / "cmake"
            if cmake_path.exists():
                return cmake_path

    return "cmake"
