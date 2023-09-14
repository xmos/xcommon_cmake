Compiler Flags
^^^^^^^^^^^^^^

Options to the compiler can be set for all sources in an application or module, and also
independent sets of compiler options can be specified for build configs and individual
source files.

This example demonstrates the hierarchy of how these options interact. The ``MSG_NUM``
macro is defined for a config, so it applies to all sources. Then the ``FLAG0`` and ``FLAG1``
macros are defined for specific files, so they are undefined in the other sources (and
successful compilation of this example proves this as the ``#error`` directives are not
reached.

Directory structure
"""""""""""""""""""

.. code-block::

    sandbox/
           |-- sw_cflags/
                        |-- app_cflags/
                                      |-- CMakeLists.txt
                                      |-- src/
                                             |-- flag0.c
                                             |-- flag1.c
                                             |-- main.c

CMake and source file contents
""""""""""""""""""""""""""""""

`sandbox/sw_cflags/app_cflags/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake)
    project(cflags)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)

    set(APP_COMPILER_FLAGS_config0 -DMSG_NUM=0)
    set(APP_COMPILER_FLAGS_config1 -DMSG_NUM=1)

    set(APP_COMPILER_FLAGS_flag0.c -DFLAG0=0)
    set(APP_COMPILER_FLAGS_flag1.c -DFLAG1=1)

    XMOS_REGISTER_APP()

`sandbox/sw_cflags/app_cflags/src/flag0.c`

.. code-block:: c

    #include <stdio.h>

    #ifndef FLAG0
    #error
    #endif

    #ifdef FLAG1
    #error
    #endif

    void flag0() {
        printf("%d:%d\n", MSG_NUM, FLAG0);
    }

`sandbox/sw_cflags/app_cflags/src/flag1.c`

.. code-block:: c

    #include <stdio.h>

    #ifdef FLAG0
    #error
    #endif

    #ifndef FLAG1
    #error
    #endif

    void flag1() {
        printf("%d:%d\n", MSG_NUM, FLAG1);
    }

`sandbox/sw_cflags/app_cflags/src/main.c`

.. code-block:: c

    #include <stdio.h>

    #ifdef FLAG0
    #error
    #endif

    #ifdef FLAG1
    #error
    #endif

    void flag0();
    void flag1();

    int main() {
        printf("config%d\n", MSG_NUM);
        flag0();
        flag1();
        return 0;
    }

Build instructions
""""""""""""""""""

Commands to build and run app, from working directory ``sandbox/sw_cflags/app_cflags``:

.. code-block:: console

    cmake -G Ninja -B build
    cd build
    ninja

The build products are:

- ``bin/config0/cflags_config0.xe``
- ``bin/config1/cflags_config1.xe``

These binaries can be run with xsim to see the difference in their printed output.

.. code-block:: console

    $> xsim bin/config0/cflags_config0.xe
    config0
    0:0
    0:1

    $> xsim bin/config1/cflags_config1.xe
    config1
    1:0
    1:1
