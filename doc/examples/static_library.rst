Static Library
^^^^^^^^^^^^^^

Library ``my_lib`` will be compiled as a static library to link into applications, rather than
be used as a module. It has one dependency, ``lib0``.

Directory structure
"""""""""""""""""""

.. code-block::

    sandbox/
           |-- lib0/
           |       |-- lib0/
           |               |-- api/
           |               |-- CMakeLists.txt
           |               |-- src/
           |-- my_lib/
                     |-- CMakeLists.txt
                     |-- my_lib/
                               |-- api/
                               |-- CMakeLists.txt
                               |-- libsrc/

CMake file contents
"""""""""""""""""""

`sandbox/my_lib/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake)
    project(my_lib)

    add_subdirectory(my_lib)

`sandbox/my_lib/my_lib/CMakeLists.txt`

.. code-block:: cmake

    set(LIB_NAME my_lib)
    set(LIB_VERSION 1.2.3)
    set(LIB_ARCH xs2a xs3a)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "lib0(3.2.0)")

    XMOS_STATIC_LIBRARY()

`sandbox/lib0/lib0/CMakeLists.txt`

.. code-block:: cmake

    set(LIB_NAME lib0)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()

Build instructions
""""""""""""""""""

Commands to build the static libraries, from working directory ``sandbox/my_lib``:

.. code-block:: console

    cmake -G Ninja -B build
    ninja -C build

A static library archive is created for each architecture, with a cmake include file
so that it can be added to an application project and linked into a binary.

- ``my_lib/lib/xs2a/libmy_lib.a`` included via ``my_lib/lib/my_lib-xs2a.cmake``
- ``my_lib/lib/xs3a/libmy_lib.a`` included via ``my_lib/lib/my_lib-xs3a.cmake``
