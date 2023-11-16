Dependency Management
---------------------

XCommon CMake provides a dependency management solution which can fetch modules to be used in an application.
These modules are cloned from git repositories and placed in the root of the sandbox.

Starting from the application's CMakeLists.txt, the ``APP_DEPENDENT_MODULES`` variable defines the immediate
dependencies of the application. When each ``lib_build_info.cmake`` file is included for each dependency, their
``LIB_DEPENDENT_MODULES`` variables define the sub-dependency relationships. This builds up a tree which is
traversed depth-first to populate the sandbox.

As an example, suppose that an application's ``CMakeLists.txt`` contains ``set(APP_DEPENDENT_MODULES lib_mod0 lib_mod1)``
and then the modules have the following in their ``lib_build_info.cmake`` files:

========  ====================================================
lib_mod0  ``set(LIB_DEPENDENT_MODULES "lib_mod2")``
lib_mod1  ``set(LIB_DEPENDENT_MODULES "lib_mod2" "lib_mod3")``
lib_mod2  ``set(LIB_DEPENDENT_MODULES "lib_mod3")``
lib_mod3  ``set(LIB_DEPENDENT_MODULES "")``
========  ====================================================

Then the dependent modules will be retrieved in the following order: ``lib_mod0``, ``lib_mod2``, ``lib_mod3``, ``lib_mod1``.

If a dependency is not present in the sandbox, it will be retrieved the first time it is traversed in this tree.
If it then appears again as a dependency of another module, nothing will happen because it is already present
in the sandbox.

The ``APP_DEPENDENT_MODULES`` and ``LIB_DEPENDENT_MODULES`` variables define lists of dependencies, where each
element in the list is a string that specifies where to fetch the source code from and which version to fetch.
See the :ref:`dependency-format` specification for full details of the accepted format.

Retrieval happens by cloning from a git repo, which can be accessed via HTTPS (for public repositories) or via
an SSH key if one is configured for passwordless access.

All the dependencies in the tree will be retrieved into the sandbox, if they are not already present. The location
of the root of the sandbox must be specified by the application using the ``XMOS_SANDBOX_DIR`` variable. If an
application or static library has no dependencies, this variable doesn't need to be set.

During the process of dependency resolution, if a module is already present in the sandbox it will not be modified.
If a different version of a module is subsequently required, the procedure is to use standard ``git`` commands to
change to the desired version and then run ``cmake build`` in the application directory.

Sandbox Manifest
^^^^^^^^^^^^^^^^

It is often useful to record the actual version that was used for each module, especially when tracking a branch.

Whenever ``cmake`` generates the build environment for an application or static library, a file called ``manifest.txt``
is created in the ``build`` directory. This "manifest" contains a list of the application and module dependencies, with the
columns in a table for the location from which the module was cloned, and the branch/tag and git commit hash for the
current checked out changeset. If any columns are not applicable, they will contain a hyphen.

Dependency Location
^^^^^^^^^^^^^^^^^^^

By default, the location of dependent modules is the root of the sandbox as defined by the ``XMOS_SANDBOX_DIR``
variable. This can be overridden on a per-dependency basis by setting a variable for each non-default dependency
location.

.. note::
    The recommended behaviour is to use the sandbox as defined by ``XMOS_SANDBOX_DIR`` and overriding the dependency
    location should only be done in exceptional circumstances.

A variable named ``XMOS_DEP_DIR_<module>`` can be used to override the location of dependency ``<module>``.
For example, ``XMOS_DEP_DIR_lib_i2c`` could be set to the path of the root of a copy of the lib_i2c module in
a location other than the root of the sandbox. Then the build system will search for source code for lib_i2c in
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
