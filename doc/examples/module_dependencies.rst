Module Dependencies
^^^^^^^^^^^^^^^^^^^

Application ``my_app`` requires modules ``lib0`` and ``lib1``, and ``lib1`` requires ``lib2``.

Directory structure
"""""""""""""""""""

.. code-block::

    sandbox/
           |-- lib0/
           |       |-- lib0/
           |               |-- api/
           |               |-- CMakeLists.txt
           |               |-- src/
           |-- lib1/
           |       |-- lib1/
           |               |-- api/
           |               |-- CMakeLists.txt
           |               |-- src/
           |-- lib2/
           |       |-- lib2/
           |               |-- api/
           |               |-- CMakeLists.txt
           |               |-- src/
           |-- my_app/
                     |-- CMakeLists.txt
                     |-- src/

CMake file contents
"""""""""""""""""""

`sandbox/my_app/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake)
    project(my_app)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)
    set(APP_DEPENDENT_MODULES "lib0(3.2.0)"
                              "lib1(1.0.0)")

    XMOS_REGISTER_APP()

`sandbox/lib0/lib0/CMakeLists.txt`

.. code-block:: cmake

    set(LIB_NAME lib0)
    set(LIB_VERSION 3.2.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()

`sandbox/lib1/lib1/CMakeLists.txt`

.. code-block:: cmake

    set(LIB_NAME lib1)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "lib2(2.5.1)")

    XMOS_REGISTER_MODULE()

`sandbox/lib2/lib2/CMakeLists.txt`

.. code-block:: cmake

    set(LIB_NAME lib2)
    set(LIB_VERSION 2.5.1)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()


Build instructions
""""""""""""""""""

Commands to build and run app, from working directory ``sandbox/my_app``:

.. code-block:: console

    cmake -G Ninja -B build
    ninja -C build

The build product is ``bin/my_app.xe``.
