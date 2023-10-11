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
           |                       |-- CMakeLists.txt
           |                       |-- src/
           |-- lib_abc/
                      |-- CMakeLists.txt
                      |-- lib_abc/
                                 |-- api/
                                 |-- CMakeLists.txt
                                 |-- libsrc/

CMake file contents
"""""""""""""""""""

`sandbox/lib_abc/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(lib_abc)

    add_subdirectory(lib_abc)

`sandbox/lib_abc/lib_abc/CMakeLists.txt`

.. code-block:: cmake

    set(LIB_NAME lib_abc)
    set(LIB_VERSION 1.2.3)
    set(LIB_ARCH xs2a xs3a)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "lib_mod0(3.2.0)")

    XMOS_STATIC_LIBRARY()

`sandbox/lib_mod0/lib_mod0/CMakeLists.txt`

.. code-block:: cmake

    set(LIB_NAME lib_mod0)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()

Build instructions
""""""""""""""""""

Commands to build the static libraries, from working directory ``sandbox/lib_abc``:

.. code-block:: console

    cmake -G Ninja -B build
    cd build
    ninja

A static library archive is created for each architecture, with a cmake include file
so that it can be added to an application project and linked into an executable.

- ``sandbox/lib_abc/lib_abc/lib/xs2a/liblib_abc.a`` included via ``sandbox/lib_abc/lib_abc/lib/lib_abc-xs2a.cmake``
- ``sandbox/lib_abc/lib_abc/lib/xs3a/liblib_abc.a`` included via ``sandbox/lib_abc/lib_abc/lib/lib_abc-xs3a.cmake``
