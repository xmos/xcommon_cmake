Optional Headers
^^^^^^^^^^^^^^^^

Application ``my_app`` requires modules ``lib0``, and ``lib0`` supports an optional header file.

Directory structure
"""""""""""""""""""

.. code-block::

    sandbox/
           |-- lib0/
           |       |-- lib0/
           |               |-- api/
           |               |-- CMakeLists.txt
           |               |-- src/
           |-- my_app/
                     |-- CMakeLists.txt
                     |-- src/
                            |-- lib0_conf.h
                            |-- main.c

CMake file contents
"""""""""""""""""""

`sandbox/my_app/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake)
    project(my_app)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)
    set(APP_DEPENDENT_MODULES "lib0")

    XMOS_REGISTER_APP()

`sandbox/lib0/lib0/CMakeLists.txt`

.. code-block:: cmake

    set(LIB_NAME lib0)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_OPTIONAL_HEADERS lib0_conf.h)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()

Files in ``lib0`` (source or headers) can now conditionally compile code using preprocessor directives like

.. code-block:: c

    #ifdef __lib0_conf_h_exists__

For example, ``lib_conf.h`` could be conditionally included into files in ``lib0``, so that the application
can define or override constants in the module.

Build instructions
""""""""""""""""""

Commands to configure and build the app, from working directory ``sandbox/my_app``:

.. code-block:: console

    cmake -G Ninja -B build
    ninja -C build
