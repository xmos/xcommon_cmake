Optional Headers
^^^^^^^^^^^^^^^^

Application ``app_opthdr`` requires module ``lib_mod0``, and ``lib_mod0`` supports an optional header file.

Optional headers are a module feature which allows module code to be conditionally compiled based on the
presence of a header file in the application or another module. One use for this feature is to allow an
application to override the definitions of constants in the module.

Directory structure
"""""""""""""""""""

.. code-block::

    sandbox/
           |-- lib_mod0/
           |           |-- lib_mod0/
           |                       |-- api/
           |                       |-- CMakeLists.txt
           |                       |-- src/
           |-- sw_opthdr/
                        |-- app_opthdr/
                                      |-- CMakeLists.txt
                                      |-- src/
                                             |-- mod0_conf.h
                                             |-- main.c

CMake file contents
"""""""""""""""""""

`sandbox/sw_opthdr/app_opthdr/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(opthdr)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)
    set(APP_DEPENDENT_MODULES "lib_mod0")

    XMOS_REGISTER_APP()

`sandbox/lib_mod0/lib_mod0/CMakeLists.txt`

.. code-block:: cmake

    set(LIB_NAME lib_mod0)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_OPTIONAL_HEADERS mod0_conf.h)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()

Files in ``lib_mod0`` (source or headers) can now conditionally compile code using preprocessor directives like

.. code-block:: c

    #ifdef __mod0_conf_h_exists__

For example, ``mod0_conf.h`` could be conditionally included into files in ``lib_mod0``, so that the application
can define or override constants in module ``lib_mod0``.

Build instructions
""""""""""""""""""

Commands to configure and build the app, from working directory ``sandbox/sw_opthdr/app_opthdr``:

.. code-block:: console

    cmake -G "Unix Makefiles" -B build
    cd build
    xmake
