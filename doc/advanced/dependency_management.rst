Advanced Dependency Management
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Dependency Location
"""""""""""""""""""

By default, the location of dependent modules is the root of the sandbox as defined by the ``XMOS_SANDBOX_DIR``
variable. This can be overridden on a per-dependency basis by setting a variable for each non-default dependency
location.

.. note::
    The recommended behaviour is to use the sandbox as defined by ``XMOS_SANDBOX_DIR`` and overriding the dependency
    location should only be done in exceptional circumstances.

A variable named ``XMOS_DEP_DIR_<module>`` can be used to override the location of dependency ``<module>``.
For example, ``XMOS_DEP_DIR_lib_i2c`` could be set to the path of the root of a copy of the ``lib_i2c`` module in
a location other than the root of the sandbox. Then the build system will search for source code for ``lib_i2c`` in
this location, instead of in a ``lib_i2c`` directory in the root of the sandbox.

Any sub-dependencies of this module will be found in their default location in ``XMOS_SANDBOX_DIR`` unless they
too have an override named variable with their module name.

CMake file contents
"""""""""""""""""""

Returning to the previous example sandbox structure we will now examine the contents of the ``CMakeLists.txt``
and ``lib_build_info.cmake`` files when using ``XMOS_DEP_DIR_lib_mod1`` to specify an non-standard location for
``lib_mod1``.

.. code-block::

    sandbox/
           |-- lib_mod0/
           |           |-- lib_mod0/
           |                       |-- api/
           |                       |-- src/
           |                       |-- lib_build_info.cmake
           |
           |-- sw_app0/
           |          |-- app_app0_xcoreai/
           |                              |-- src/
           |                              |-- CMakeLists.txt
    other_srcs/
              |-- lib_mod1/
                          |-- lib_mod1/
                                      |-- api/
                                      |-- src/
                                      |-- lib_build_info.cmake

`sandbox/sw_app0/app_app0_xcoreai/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(app0_xcoreai)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)
    set(APP_DEPENDENT_MODULES "lib_mod0")

    set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)
    set(XMOS_DEP_DIR_lib_mod1 ${CMAKE_CURRENT_LIST_DIR}/../../../other_srcs/lib_mod1)

    XMOS_REGISTER_APP()

`sandbox/lib_mod0/lib_mod0/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_mod0)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "lib_mod1")

    XMOS_REGISTER_MODULE()

`other_srcs/lib_mod1/lib_mod1/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_mod1)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()
