from pathlib import Path
import platform
import pytest
import shutil
import subprocess


def list_test_dirs():
    base_dir = Path(__file__).parent
    exclude = [".pytest_cache", "__pycache__"]
    dirs = [d.name for d in base_dir.iterdir() if d.is_dir()]
    return [d for d in dirs if d not in exclude]


@pytest.mark.parametrize("test_dir", list_test_dirs())
def test_cmake(test_dir):
    test_dir = Path(__file__).parent / test_dir
    build_dir = test_dir / "build"
    toolchain_file = "../../xmos_cmake_toolchain/xs3a.cmake"

    # Run cmake; assumes that default generator is Ninja on Windows, otherwise Unix Makefiles
    ret = subprocess.run(["cmake", f"-DCMAKE_TOOLCHAIN_FILE={toolchain_file}", "-B", "build", "."], cwd=test_dir)
    assert(ret.returncode == 0)

    # Build
    build_tool = "ninja" if platform.system() == "Windows" else "make"
    ret = subprocess.run([build_tool], cwd=build_dir)
    assert(ret.returncode == 0)

    # Run the XE
    run_expect = test_dir / "run.expect"
    if run_expect.exists():
        ret = subprocess.run(["xsim", "a.xe"], cwd=build_dir, capture_output=True, text=True)
        assert(ret.returncode == 0)
        with open(run_expect, "r") as f:
            assert(f.read() == ret.stdout)

    # Cleanup
    shutil.rmtree(build_dir)
