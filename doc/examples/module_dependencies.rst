Module Dependencies
^^^^^^^^^^^^^^^^^^^

Application ``app_moddeps`` requires modules ``lib_mod0`` and ``lib_mod1``, and ``lib_mod1``
requires ``lib_mod2``.

Directory structure
"""""""""""""""""""

.. code-block::

    sandbox/
           |-- lib_mod0/
           |           |-- lib_mod0/
           |                       |-- api/
           |                       |-- lib_build_info.cmake
           |                       |-- src/
           |-- lib_mod1/
           |           |-- lib_mod1/
           |                       |-- api/
           |                       |-- lib_build_info.cmake
           |                       |-- src/
           |-- lib_mod2/
           |           |-- lib_mod2/
           |                       |-- api/
           |                       |-- lib_build_info.cmake
           |                       |-- src/
           |-- sw_moddeps/
                         |-- app_moddeps/
                                        |-- CMakeLists.txt
                                        |-- src/

CMake file contents
"""""""""""""""""""

`sandbox/sw_moddeps/app_moddeps/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(moddeps)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)
    set(APP_DEPENDENT_MODULES "lib_mod0(3.2.0)"
                              "lib_mod1(1.0.0)")

    XMOS_REGISTER_APP()

`sandbox/lib_mod0/lib_mod0/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_mod0)
    set(LIB_VERSION 3.2.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()

`sandbox/lib_mod1/lib_mod1/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_mod1)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "lib_mod2(2.5.1)")

    XMOS_REGISTER_MODULE()

`sandbox/lib_mod2/lib_mod2/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_mod2)
    set(LIB_VERSION 2.5.1)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()


Build instructions
""""""""""""""""""

Commands to build and run app, from working directory ``sandbox/sw_moddeps/app_moddeps``:

.. code-block:: console

    cmake -G "Unix Makefiles" -B build
    cd build
    xmake

The build product is ``bin/moddeps.xe``.
