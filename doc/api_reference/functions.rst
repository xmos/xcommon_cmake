Functions
---------

CMake Boilerplate
^^^^^^^^^^^^^^^^^

Some CMake function calls are required in the application or static library CMakeLists.txt file.

``cmake_minimum_required``
  This is used to set the minimum version of CMake based on the language features used. Your version of
  CMake must not be lower than the version set in this function call. An appropriate value is the minimum
  version of CMake supported by CMake XCommon, as reported in the Quick Start Guide.

``include($ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake)``
  This is the inclusion of the xcore toolchain and the functions provided by CMake XCommon. The environment
  variable XMOS_CMAKE_PATH will be set by enabling the XTC Tools environment.

``project``
  This function takes an argument which will be used as the base name for the application. If ``my_app``
  is set here, the XE binary for the default config build will be called ``my_app.xe``.

These three lines should be present at the beginning of an application or static library CMakeLists.txt
file.

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xmos_utils.cmake)
    project(my_app)

    # Now you can write the rest of your CMake for CMake XCommon

.. _cmake-xcommon-functions:

CMake XCommon Functions
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

``XMOS_REGISTER_MODULE()``
  This function is called after setting the :ref:`required-module-variables` and any
  :ref:`optional-application-variables`, to perform the following:

  - check the major version number of the module for compatibility
  - fetch any missing dependencies of the module
  - set compiler options for module source files
  - add module sources to the executable build targets
  - populate the manifest with an entry for the module

  This function is called recursively when adding module dependencies which use this function.

``XMOS_STATIC_LIBRARY()``
  This function is called after setting the :ref:`required-staticlib-variables` and any
  :ref:`optional-staticlib-variables`, to perform the following:

  - define the static library build targets
  - add static library sources to the build targets
  - set compiler options for the static library sources
  - populate the manifest with an entry for the application
  - fetch any missing dependencies
  - configure the immediate dependencies
  - create the cmake inclusion file for linking this static library into an application
