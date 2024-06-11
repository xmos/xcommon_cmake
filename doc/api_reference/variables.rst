.. _reference-variables:

Variables
---------

XCommon CMake relies on named variables which can be set for application and library code. These
variables must be set before calling the :ref:`xcommon-cmake-functions`. The order in which the
variables are set does not matter.

Applications
^^^^^^^^^^^^

.. _required-application-variables:

Required application variables
""""""""""""""""""""""""""""""

``APP_HW_TARGET``
  The target name or filename of an XN file to define the target platform.
  If a filename is provided, the full path is not required; the child directories of the application
  directory will be searched and the first file matching this name is used. Examples:

  .. code-block:: cmake

    set(APP_HW_TARGET XCORE-AI-EXPLORER)
    set(APP_HW_TARGET xk-316-mc.xn)

  Advanced: this variable is not required if exclusively performing :ref:`native-builds`.

``XMOS_SANDBOX_DIR``
  The path to the root of the sandbox directory. This is only required if ``APP_DEPENDENT_MODULES``
  is non-empty. See :ref:`sandbox-structure`.

  .. code-block:: cmake

    set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)

.. _optional-application-variables:

Optional application variables
""""""""""""""""""""""""""""""

``APP_ASM_SRCS``
  List of assembly source files to compile. File paths are relative to the application directory.
  If not set, all ``*.S`` files in the ``src`` directory and its subdirectories will be compiled.
  An empty string can be set to avoid compiling any assembly sources. Examples:

  .. code-block:: cmake

    set(APP_ASM_SRCS src/feature0/f0.S src/feature1/f1.S)
    set(APP_ASM_SRCS "")

``APP_C_SRCS``
  List of C source files to compile. File paths are relative to the application directory. If not
  set, all ``*.c`` files in the ``src`` directory and its subdirectories will be compiled. An empty
  string can be set to avoid compiling any C sources. Examples:

  .. code-block:: cmake

    set(APP_C_SRCS src/feature0/f0.c src/feature1/f1.c)
    set(APP_C_SRCS "")

``APP_COMPILER_FLAGS``
  List of options to the compiler for use when compiling all source files, except those which have
  their own options via the ``APP_COMPILER_FLAGS_<filename>`` variable. This variable should also be
  used for compiler definitions via the ``-D`` option. Default: empty list which provides no
  compiler options. Example:

  .. code-block:: cmake

    set(APP_COMPILER_FLAGS -g -O3 -Wall -DMY_DEF=123)

``APP_COMPILER_FLAGS_<config>``
  List of options to the compiler for use when compiling all source files for the specified config,
  except those which have their own options via the ``APP_COMPILER_FLAGS_<filename>`` variable.
  This variable should also be used for compiler definitions via the ``-D`` option. Default: empty
  list which provides no compiler options. Example:

  .. code-block:: cmake
  
    set(APP_COMPILER_FLAGS_config0 -g -O2 -DMY_DEF=456)

``APP_COMPILER_FLAGS_<filename>``
  List of options to the compiler for use when compiling the specified file. Only the filename is
  required, not a full path to the file; these compiler options will be used when compiling all
  files in the application directory which have that filename. This variable should also be used
  for compiler definitions via the ``-D`` option. Default: empty list which provides no compiler
  options. Example:

  .. code-block:: cmake

    set(APP_COMPILER_FLAGS_feature0.c -Os -DMY_DEF=789)

``APP_CXX_SRCS``
  List of C++ source files to compile. File paths are relative to the application directory. If
  not set, all ``*.cpp`` files in the ``src`` directory and its subdirectories will be compiled.
  An empty string can be set to avoid compiling any C++ sources. Examples:

  .. code-block:: cmake

    set(APP_CXX_SRCS src/feature0/f0.cpp src/feature1/f1.cpp)
    set(APP_CXX_SRCS "")

``APP_DEPENDENT_MODULES``
  List of this application's dependencies, which must be present when compiling. See the separate
  dependency management section about the dependency fetching process and the acceptable format
  for values in this list. Unlike other variables, the values to set for ``APP_DEPENDENT_MODULES``
  should be quoted, as this is required when the string contains parentheses. Default: empty list,
  so the application has no dependencies. Example:

  .. code-block:: cmake

    set(APP_DEPENDENT_MODULES "lib_i2c(6.1.1)"
                              "lib_i2s(5.0.0)")

``APP_INCLUDES``
  List of directories to add to the compiler's include search path when compiling sources.
  Default: empty list, so no directories are added. Example:

  .. code-block:: cmake

    set(APP_INCLUDES src src/feature0)

``APP_PCA_ENABLE``
  Boolean option to enable Pre-Compilation Analysis for XC source files. Default: ``OFF``. Example:

  .. code-block:: cmake

    set(APP_PCA_ENABLE ON)

``APP_XC_SRCS``
  List of XC source files to compile. File paths are relative to the application directory. If
  not set, all ``*.xc`` files in the ``src`` directory and its subdirectories will be compiled.
  An empty string can be set to avoid compiling any XC sources. Examples:

  .. code-block:: cmake

    set(APP_XC_SRCS src/feature0/f0.xc src/feature1/f1.xc)
    set(APP_XC_SRCS "")

``APP_XSCOPE_SRCS``
  List of xscope configuration files to use in the application. File paths are relative to the
  application directory. If not set, all ``*.xscope`` files in the ``src`` directory and its
  subdirectories will be used. An empty string can be set to avoid using any xscope configuration
  files. Examples:

  .. code-block:: cmake

    set(APP_XSCOPE_SRCS src/config.xscope)
    set(APP_XSCOPE_SRCS "")

``SOURCE_FILES_<config>``
  List of source files to use only when building the specified application config. Each application
  config initially has the same source file list, which is created according to the behaviour of the
  language-specific source list variables. Then for each application config, sources are removed
  from their list if a different application config has specified that file in its
  ``SOURCE_FILES_<config>`` variable.

  .. code-block:: cmake

    set(SOURCE_FILES_config0 src/config0.c)

``XMOS_DEP_DIR_<module>``
  Directory containing the dependency ``<module>`` as an override to the default sandbox root
  directory in ``XMOS_SANDBOX_DIR``. This is the path to the root of the module.

  .. code-block:: cmake

    set(XMOS_DEP_DIR_lib_i2c /home/user/lib_i2c)

Modules
^^^^^^^

.. _required-module-variables:

Required module variables
"""""""""""""""""""""""""

``LIB_DEPENDENT_MODULES``
  List of this module's dependencies, which must be present when compiling. See the separate
  dependency management section about the dependency fetching process and the acceptable format
  for values in this list. If this module has no dependencies, this variable must be set as
  an empty string.  Unlike other variables, the values to set for ``LIB_DEPENDENT_MODULES``
  should be quoted, as this is required when the string contains parentheses. Examples:

  .. code-block:: cmake

    set(LIB_DEPENDENT_MODULES "lib_logging(3.1.1)"
                              "lib_xassert(4.1.0)")
    set(LIB_DEPENDENT_MODULES "")

``LIB_INCLUDES``
  List of directories to add to the compiler's include search path when compiling sources.
  Example:

  .. code-block:: cmake

    set(LIB_INCLUDES api src/feature0)

``LIB_NAME``
  String of the name for this module. This string will be the name used by the dependent
  modules list variables for any applications/modules that require this module. Example:

  .. code-block:: cmake

    set(LIB_NAME lib_logging)

``LIB_VERSION``
  String of the three-part version number for this module. Example:

  .. code-block:: cmake

    set(LIB_VERSION 3.1.1)

.. _optional-module-variables:

Optional module variables
"""""""""""""""""""""""""

``LIB_ASM_SRCS``
  List of assembly source files to compile. File paths are relative to the module directory.
  If not set, all ``*.S`` files in the ``src`` directory and its subdirectories will be compiled.
  An empty string can be set to avoid compiling any assembly sources. Examples:

  .. code-block:: cmake

    set(LIB_ASM_SRCS src/feature0/f0.S src/feature1/f1.S)
    set(LIB_ASM_SRCS "")

``LIB_C_SRCS``
  List of C source files to compile. File paths are relative to the module directory. If not
  set, all ``*.c`` files in the ``src`` directory and its subdirectories will be compiled. An
  empty string can be set to avoid compiling any C sources. Examples:

  .. code-block:: cmake

    set(LIB_C_SRCS src/feature0/f0.c src/feature1/f1.c)
    set(LIB_C_SRCS "")

``LIB_COMPILER_FLAGS``
  List of options to the compiler for use when compiling all source files, except those which have
  their own options via the ``LIB_COMPILER_FLAGS_<filename>`` variable. This variable should also be
  used for compiler definitions via the ``-D`` option. Default: empty list which provides no
  compiler options. Example:

  .. code-block:: cmake

    set(LIB_COMPILER_FLAGS -g -O3 -Wall -DMY_DEF=123)

``LIB_COMPILER_FLAGS_<filename>``
  List of options to the compiler for use when compiling the specified file. Only the filename is
  required, not a full path to the file; these compiler options will be used when compiling all
  files in the module directory which have that filename. This variable should also be used for
  compiler definitions via the ``-D`` option. Default: empty list which provides no compiler options.
  Example:

  .. code-block:: cmake

    set(APP_COMPILER_FLAGS_feature0.c -Os -DMY_DEF=456)

``LIB_CXX_SRCS``
  List of C++ source files to compile. File paths are relative to the module directory. If not
  set, all ``*.cpp`` files in the ``src`` directory and its subdirectories will be compiled.
  An empty string can be set to avoid compiling any C++ sources. Examples:

  .. code-block:: cmake

    set(LIB_CXX_SRCS src/feature0/f0.cpp src/feature1/f1.cpp)
    set(LIB_CXX_SRCS "")

``LIB_OPTIONAL_HEADERS``
  List of header files that can optionally be present in an application or module which requires
  this module. These files are not present in this module. If they are present in an application
  or module, the preprocessor macro ``__<name>_h_exists__`` will be set. Files within this module
  can then contain code which is conditionally compiled based on the presence of these optional
  headers in other applications. Every module or static library has an automatic optional header;
  for a library named ``lib_foo``, the optional header ``foo_conf.h`` will automatically be
  configured, so it doesn't need to be set in this variable. Default: empty list which provides no
  optional headers. Example:

  .. code-block:: cmake

    set(LIB_OPTIONAL_HEADERS abc_conf.h)

``LIB_XC_SRCS``
  List of XC source files to compile. File paths are relative to the module directory. If not
  set, all ``*.xc`` files in the ``src`` directory and its subdirectories will be compiled. An
  empty string can be set to avoid compiling any XC sources. Examples:

  .. code-block:: cmake

    set(LIB_XC_SRCS src/feature0/f0.xc src/feature1/f1.xc)
    set(LIB_XC_SRCS "")

``LIB_XSCOPE_SRCS``
  List of xscope configuration files to use for this module. File paths are relative to the module
  directory. If not set, all ``*.xscope`` files in the ``src`` directory and its subdirectories will
  be used. An empty string can be set to avoid using any xscope configuration files for this module.
  Examples:

  .. code-block:: cmake

    set(LIB_XSCOPE_SRCS src/config.xscope)
    set(LIB_XSCOPE_SRCS "")

Static Libraries
^^^^^^^^^^^^^^^^

.. _required-staticlib-variables:

Required static library variables
"""""""""""""""""""""""""""""""""

The same as the :ref:`required-module-variables`, and also:

``XMOS_SANDBOX_DIR``
  The path to the root of the sandbox directory. This is only required if ``LIB_DEPENDENT_MODULES``
  is non-empty. This must be set in the static library's ``CMakeLists.txt`` file before including
  ``lib_build_info.cmake``. See :ref:`sandbox-structure`.

  .. code-block:: cmake

    set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)

.. _optional-staticlib-variables:

Optional static library variables
"""""""""""""""""""""""""""""""""

The same as the :ref:`optional-module-variables`, and also:

``LIB_ADD_INC_DIRS``
  List of directories which are required on the include directory search path for the compilation of
  the additional source files as found based on the ``LIB_ADD_SRC_DIRS`` variable. This list of
  directories will be added to the include directory search path of the application. If this string
  is unset or empty, no additional directories will be added to the include directory search path.
  Examples:

  .. code-block:: cmake

    set(LIB_ADD_INC_DIRS inc0 inc1)
    set(LIB_ADD_INC_DIRS extra/inc)

``LIB_ADD_SRCS_DIRS``
  List of directories which contain additional source files which will be compiled and linked during
  the building of the application with which this static library is being linked. These directories
  are searched recursively, so only the highest-level directories are required. All source files
  from the result of this search will be compiled with the application; it is not possible to select
  individual additional source files for compilation. If this string is unset or empty, no search
  for additional sources will be performed, so no additional source files will be compiled. Examples:

  .. code-block:: cmake

    set(LIB_ADD_SRC_DIRS src0 src1)
    set(LIB_ADD_SRC_DIRS extra/src)

``LIB_ARCH``
  List of xcore architectures for which to build static libraries. For each architecture, a separate
  static library archive will be built. If empty or undefined, the default is ``xs3a``. Examples:

  .. code-block:: cmake

    set(LIB_ARCH xs2a)
    set(LIB_ARCH xs2a xs3a)

Output Variables
^^^^^^^^^^^^^^^^

Experienced CMake users are able to add custom CMake code around the XCommon CMake build system. To
support this, some variables are exposed from the ``XMOS_REGISTER_APP`` function.

``APP_BUILD_TARGETS``
  List of the target names for the applications which have been configured. This allows relationships to
  be defined with custom CMake targets that a user may create.

``APP_BUILD_ARCH``
  String of the architecture of the application being built. This variable allows the CMake code for a
  module to be conditionally configured based on the target architecture.
