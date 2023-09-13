Quick Start Guide
-----------------

.. _`software-requirements`:

Software Requirements
^^^^^^^^^^^^^^^^^^^^^
- `CMake <https://cmake.org>`_ (minimum version 3.21)
- `Git <https://git-scm.com>`_ (minimum version 2.25)
- `Ninja <https://ninja-build.org>`_ (minimum version 1.11.0)

Hello World Example
^^^^^^^^^^^^^^^^^^^

This example is a simple "Hello world" application to demonstrate a minimal project using CMake XCommon.

Create the following file structure, with the contents shown below:

.. code-block::

    app_hello_world/
                   |-- CMakeLists.txt
                   |-- src/
                          |-- main.c

`app_hello_world/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake)
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

Build the binary and run it using the simulator:

.. code-block:: console

    cmake -G Ninja -B build
    ninja -C build
    xsim bin/hello_world.xe

The message "Hello world" is displayed.
