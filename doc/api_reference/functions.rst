Functions
---------

.. _cmake-header:

CMake Header
^^^^^^^^^^^^

Some CMake function calls are required in the application or static library ``CMakeLists.txt`` file.

``cmake_minimum_required``
  This is used to set the minimum version of CMake based on the language features used. Your version of
  CMake must not be lower than the version set in this function call. An appropriate value is the minimum
  version of CMake supported by XCommon CMake, as reported in the Quick Start Guide.

``include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)``
  This is the inclusion of the xcore toolchain and the functions provided by XCommon CMake. The environment
  variable XMOS_CMAKE_PATH will be set by enabling the XTC Tools environment.

``project``
  This function takes an argument which will be used as the base name for the application. If ``my_app``
  is set here, the XE executable for the default config build will be called ``my_app.xe``.

These three lines must be present at the beginning of an application or static library ``CMakeLists.txt``
file.

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(my_app)

    # Now ready for the XCommon CMake code for the application or static library

.. _xcommon-cmake-functions:

XCommon CMake Functions
^^^^^^^^^^^^^^^^^^^^^^^

``XMOS_REGISTER_APP()``
  This function is called after setting the :ref:`required-application-variables` and any
  :ref:`optional-application-variables` inside an application, to perform the following:

  - define the application build targets
  - add application sources to the executable build targets
  - set compiler options for each build config
  - populate the manifest with an entry for the application
  - fetch any missing dependencies
  - configure the immediate dependencies
  - check presence of optional headers
  - create commands for PCA, if enabled

.. note::

   Pre-compilation Analysis (PCA) provides whole program optimisation but is only applicable to XC
   source files.

``XMOS_REGISTER_MODULE()``
  This function is called after setting the :ref:`required-module-variables` and any
  :ref:`optional-application-variables`, to perform the following:

  - check the major version number of the module for compatibility
  - fetch any missing dependencies of the module
  - set compiler options for module source files
  - add module sources to the executable build targets
  - populate the manifest with an entry for the module

  This function is called recursively when adding module dependencies which use this function.

``XMOS_REGISTER_STATIC_LIB()``
  This function is called after setting the :ref:`staticlib-variables` and it can be used in two ways.

  Firstly, if CMake is being run from the static library directory, this function will:

  - define the static library build targets
  - add static library sources to the build targets
  - set compiler options for the static library sources
  - populate the manifest with an entry for the static library
  - fetch any missing dependencies
  - configure the immediate dependencies

Alternatively, if the static library is a dependency of an application, this function is called as
a result of the dependency configuration for the application. In that case, it will link the static
library into all of the application build targets.
