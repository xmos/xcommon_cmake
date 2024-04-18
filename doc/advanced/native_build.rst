.. _`native-builds`:

Native CPU Builds
-----------------

XCommon CMake supports building libraries and applications for the native host CPU instead of for an
xcore device. An example use-case for this feature would be to compile and run a unit test to check the
logic of a signal-processing algorithm, where the higher clock speed of a non-embedded CPU allows
greater test coverage for the available amount of time.

This is advanced usage of XCommon CMake, and not all modules are guaranteed to have native build support.

CMake Generation
^^^^^^^^^^^^^^^^

The ``BUILD_NATIVE`` option must be enabled for the CMake command that generates the build environment,
and then the build can continue as normal to produce libraries and applications for the host CPU. The
build environment will be configured with the default compiler toolchain for the system, so a suitable
toolchain must be installed as a prerequisite.

.. code-block:: console

    cmake -G "Unix Makefiles" -B build -D BUILD_NATIVE=ON
    cd build
    xmake

Conditional Configuration
^^^^^^^^^^^^^^^^^^^^^^^^^

If an application or library supports building for an xcore device as well as for the native host CPU,
it is possible that the values of XCommon CMake variables need to be set to different values based on
which build is being performed. For example, compilation for the native build may occur with a toolchain
that requires different compiler options. These variables can be set inside conditional blocks to achieve
the desired behaviour.

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(app)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)

    if(NOT BUILD_NATIVE)
        # Compiler options for xcore build
        set(APP_COMPILER_OPTIONS -Os -mno-dual-issue)
    else()
        # Compiler options for native build
        set(APP_COMPILER_OPTIONS -O2)
    endif()
