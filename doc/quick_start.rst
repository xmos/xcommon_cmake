Quick Start Guide
-----------------

.. _`software-requirements`:

Software Requirements
^^^^^^^^^^^^^^^^^^^^^

- `CMake <https://cmake.org>`__ (minimum version 3.21)
- `Git <https://git-scm.com>`__ (minimum version 2.25)
- `XTC Tools <https://www.xmos.com/software-tools>`__ (minimum version 15.2.1)

Setup
^^^^^

Before using XCommon CMake, the environment variable ``XMOS_CMAKE_PATH`` must be set to the location of
the ``xcommon_cmake`` directory.

.. tab:: MacOS and Linux

    .. code-block:: console

       # MacOS and Linux
       export XMOS_CMAKE_PATH=/home/user/xcommon_cmake

.. tab:: Windows

    .. code-block:: console

       # Windows
       set XMOS_CMAKE_PATH=C:\Users\user\xcommon_cmake

When XCommon CMake is integrated into XTC Tools, the user will no longer have to set this environment variable
themself as it will be configured in the XTC Tools environment. At this point, XTC Tools will no longer be a
software requirement of XCommon CMake, because XCommon CMake will be distributed as part of XTC Tools.

Hello World Example
^^^^^^^^^^^^^^^^^^^

This example is a simple "Hello world" application to demonstrate a minimal project using XCommon CMake.

Create the following file structure, with the contents shown below:

.. code-block::

    app_hello_world/
                   |-- CMakeLists.txt
                   |-- src/
                          |-- main.c

`app_hello_world/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(hello_world)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)

    XMOS_REGISTER_APP()

`app_hello_world/src/main.c`

.. code-block:: c

    #include <stdio.h>

    int main() {
        printf("Hello world\n");
        return 0;
    }

Build the executable and run it using the simulator:

.. code-block:: console

    cmake -G "Unix Makefiles" -B build
    cd build
    xmake
    cd ..
    xsim bin/hello_world.xe

The message "Hello world" is displayed.
