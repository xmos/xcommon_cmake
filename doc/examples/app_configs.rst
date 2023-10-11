Application Configs
^^^^^^^^^^^^^^^^^^^

Application ``app_cfgs`` has two build configs, which in this trivial case change the value
of a printed message. When using multiple configs in your application, the same source files
are compiled for each config, but different compiler flags can be supplied to each config.

Directory structure
"""""""""""""""""""

.. code-block::

    sandbox/
           |-- sw_cfgs/
                      |-- app_cfgs/
                                  |-- CMakeLists.txt
                                  |-- src/
                                         |-- main.c

CMake and source file contents
""""""""""""""""""""""""""""""

`sandbox/sw_cfgs/app_cfgs/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake)
    project(cfgs)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)
    set(APP_COMPILER_FLAGS_config0 -DMSG_NUM=0)
    set(APP_COMPILER_FLAGS_config1 -DMSG_NUM=1)

    XMOS_REGISTER_APP()

`sandbox/sw_cfgs/app_cfgs/src/main.c`

.. code-block:: c

    #include <stdio.h>

    int main() {
        printf("config%d\n", MSG_NUM);
        return 0;
    }

Build instructions
""""""""""""""""""

Commands to build and run app, from working directory ``sandbox/sw_cfgs/app_cfgs``:

.. code-block:: console

    cmake -G Ninja -B build
    cd build
    ninja

The build products are:

- ``bin/config0/cfgs_config0.xe``
- ``bin/config1/cfgs_config1.xe``

These binaries can be run with xsim to see the difference in their printed output.

.. code-block:: console

    $> xsim bin/config0/cfgs_config0.xe
    config0

    $> xsim bin/config1/cfgs_config1.xe
    config1

An individual executable target can be built, so to build only ``cfgs_config1.xe`` and not
``cfgs_config0.xe``:

.. code-block:: console

    cd build
    ninja config1
