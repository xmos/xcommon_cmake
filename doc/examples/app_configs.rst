Application Configs
^^^^^^^^^^^^^^^^^^^

Application ``my_app`` has two build configs, which in this trivial case change the value
of a printed message. When using multiple configs in your application, the same source files
are compiled for each config, but different compiler flags can be supplied to each config.

Directory structure
"""""""""""""""""""

.. code-block::

    sandbox/
           |-- my_app/
                     |-- CMakeLists.txt
                     |-- src/
                            |-- main.c

CMake and source file contents
""""""""""""""""""""""""""""""

`sandbox/my_app/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake)
    project(my_app)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)
    set(APP_COMPILER_FLAGS_config0 -DMSG_NUM=0)
    set(APP_COMPILER_FLAGS_config1 -DMSG_NUM=1)

    XMOS_REGISTER_APP()

`sandbox/my_app/src/main.c`

.. code-block:: c

    #include <stdio.h>

    int main() {
        printf("config%d\n", MSG_NUM);
        return 0;
    }

Build instructions
""""""""""""""""""

Commands to build and run app, from working directory ``sandbox/my_app``:

.. code-block:: console

    cmake -G Ninja -B build
    ninja -C build

The build products are:

- ``bin/config0/my_app_config0.xe``
- ``bin/config1/my_app_config1.xe``

These binaries can be run with xsim to see the difference in their printed output.

.. code-block:: console

    $> xsim bin/config0/my_app_config0.xe
    config0

    $> xsim bin/config1/my_app_config1.xe
    config1

Instead of building all the binaries, an individual target can be built.

.. code-block:: console

    # Just build my_app_config1.xe, not my_app_config0.xe
    ninja -C build config1
