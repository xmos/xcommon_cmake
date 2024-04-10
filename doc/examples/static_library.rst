Static Library
^^^^^^^^^^^^^^

Library ``lib_abc`` will be compiled as a static library to link into applications, rather than
be used as a module. It has one dependency, ``lib_mod0``.

Directory structure
"""""""""""""""""""

.. code-block::

    sandbox/
           |-- lib_mod0/
           |           |-- lib_mod0/
           |                       |-- api/
           |                       |      |-- mod0.h
           |                       |-- lib_build_info.cmake
           |                       |-- src/
           |                              |-- mod0.c
           |
           |-- lib_abc/
                      |-- lib_abc/
                                 |-- api/
                                 |      |-- abc.h
                                 |-- CMakeLists.txt
                                 |-- lib_build_info.cmake
                                 |-- libsrc/
                                           |-- abc.c

CMake file contents
"""""""""""""""""""

`sandbox/lib_abc/lib_abc/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(lib_abc)

    set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)
    include(lib_build_info.cmake)

`sandbox/lib_abc/lib_abc/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_abc)
    set(LIB_VERSION 1.2.3)
    set(LIB_ARCH xs2a xs3a)
    set(LIB_INCLUDES api)
    set(LIB_C_SRCS libsrc/abc.c)
    set(LIB_DEPENDENT_MODULES "lib_mod0(1.0.0)")

    XMOS_REGISTER_STATIC_LIB()

`sandbox/lib_mod0/lib_mod0/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_mod0)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()

Build instructions
""""""""""""""""""

Commands to build the static libraries, from working directory ``sandbox/lib_abc/lib_abc``:

.. code-block:: console

    cmake -G "Unix Makefiles" -B build
    cd build
    xmake

A static library archive is created for each architecture:

- ``sandbox/lib_abc/lib_abc/lib/xs2a/lib_abc.a``
- ``sandbox/lib_abc/lib_abc/lib/xs3a/lib_abc.a``
