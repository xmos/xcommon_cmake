Configuration Files
-------------------

There are four types of CMake configuration file which can be used in an XCommon CMake project.

- Application ``CMakeLists.txt``
- Module ``lib_build_info.cmake``
- Static library ``lib_build_info.cmake``
- Static library ``CMakeLists.txt``

Application CMakeLists.txt
^^^^^^^^^^^^^^^^^^^^^^^^^^

The application ``CMakeLists.txt`` file is located in the application directory as described in the
:ref:`sandbox-structure` section. This file typically has three sections.

The first section is a "header" which must be present to provide mandatory CMake function calls and
to load the XCommon CMake function definitions. The three lines in :ref:`cmake-header` are required
at the beginning of the file.

The second section of this file is usually the largest. It contains the variable definitions that
will be used by the XCommon CMake functions to configure the application. There is a set of named
variables, documented in :ref:`reference-variables`, which define the dependency relationships and
the options for the build configuration.

There are two required variables: ``APP_HW_TARGET`` is necessary to define the target device,
either by a named target defined in the XTC Tools or a local XN file; ``XMOS_SANDBOX_DIR`` must
be set to the path of the root of the sandbox (if the application has no dependencies, this
variable isn't strictly required). It is best practice to set this to a path relative to the
CMake variable ``${CMAKE_CURRENT_LIST_DIR}``, which is the directory containing this application
``CMakeLists.txt`` file.

The list of dependent modules provided in the ``APP_DEPENDENT_MODULES`` variable should only be
the direct dependencies used in the application source code. Any sub-dependencies that are
required will be defined within the modules that require them.

The final part is a call to ``XMOS_REGISTER_APP()``. This function performs the necessary actions
to populate the sandbox with dependencies and then generate the CMake build environment. All
desired XCommon CMake application variables must be set before this function is called.

Example: `sandbox/sw_example/app_example/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(app_example)

    set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)
    set(APP_HW_TARGET XCORE-AI-EXPLORER)
    set(APP_COMPILER_FLAGS -O3 -Wall)
    set(APP_DEPENDENT_MODULES "lib_foo")

    XMOS_REGISTER_APP()

Module lib_build_info.cmake
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The module code itself does not contain a ``CMakeLists.txt`` file because it is never the
entry-point for XCommon CMake. Instead, the module directory contains the file
``lib_build_info.cmake`` which allows it to be included in other XCommon CMake projects.

The ``lib_build_info.cmake`` file contains variable definitions, followed by a call to
``XMOS_REGISTER_MODULE()``. Some variable definitions are required; see
:ref:`required-module-variables`. All desired XCommon CMake module variables must be set before
the call to ``XMOS_REGISTER_MODULE()``.

In a similar way to the application variables, the ``LIB_DEPENDENT_MODULES`` variable should only
contain the direct dependencies of the module. Any sub-dependencies that are required will be
defined within the modules that require them.

Example: `sandbox/lib_foo/lib_foo/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_foo)
    set(LIB_VERSION 3.2.1)
    set(LIB_INCLUDES api)
    set(LIB_COMPILER_FLAGS -Os)
    set(LIB_DEPENDENT_MODULES "lib_bar")

    XMOS_REGISTER_MODULE()

Static library lib_build_info.cmake
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For a static library, a ``lib_build_info.cmake`` file is created to hold the XCommon CMake variable
definitions to allow it to be linked into an application. See :ref:`staticlib-variables` for the
variable definitions. All desired XCommon CMake static library variables must be set before the call
to ``XMOS_REGISTER_STATIC_LIB()``.

Example: `sandbox/lib_bar/lib_bar/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_bar)
    set(LIB_VERSION 1.0.0)
    set(LIB_ARCHS xs2a xs3a)
    set(LIB_ARCHIVE_INCLUDES api)
    set(LIB_ARCHIVE_C_SRCS libsrc/bar0.c libsrc/bar1.c)
    set(LIB_ARCHIVE_COMPILER_FLAGS -O3)
    set(LIB_ARCHIVE_DEPENDENT_MODULES "")

    XMOS_REGISTER_STATIC_LIB()

Static library CMakeLists.txt
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If the static library repository also contains the source to build it, then a ``CMakeLists.txt`` file
can be created to configure this build. It contains the same initial three lines as the application
``CMakeLists.txt`` file, with the library name set in the ``project()`` call, and then it sets the
``XMOS_SANDBOX_DIR`` variable and includes the ``lib_build_info.cmake`` described in the previous
section. This allows the XCommon CMake variables for the library to be shared between the two
workflows: building the static library archive and linking an existing archive into an application.

Example: `sandbox/lib_bar/lib_bar/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(lib_bar)

    set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)
    include(lib_build_info.cmake)
