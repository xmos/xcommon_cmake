.. _`sandbox-structure`:

Sandbox Structure
-----------------

A sandbox is a fully contained collection of source code modules which can be used to build one or
more applications.

Definitions
^^^^^^^^^^^

There are three types of top-level directories that can be present in a sandbox.

Application
  Contains a set of source files that is specific to the application that builds into one or more
  executables (.xe file). This may represent a simple example or a verified Reference Design.
  These executables are made by compiling the application's source files and the source files of
  any modules it uses.

  An application directory is prefixed with ``sw_``, and each set of application-specific code
  within is in a directory prefixed with ``app_``.

  For example, an application may implement a USB Audio Device.

Module
  Contains module source code, which can depend on other modules. Module code is compiled
  into objects which are directly linked into the application executable. XMOS module
  directories are typically prefixed with ``lib_``.

  For example, a source module may implement an IO function such as I2C

Static Library
  Contains source code and (optionally) a pre-built static library archive, which can be
  linked into the application executable. XMOS modules containing a static library are typically
  prefixed with ``lib_``.

  For example, a static library module may implement a large stack such as Tensorflow or protected
  third party IP.

Repository Layout
^^^^^^^^^^^^^^^^^

All the items defined in the `Definitions`_ section are placed in the root of the sandbox, each
typically representing a separate git repository with no nesting of applications and modules. This
allows for the possibility of merging applications and the use of shared dependencies. It also
removes issues relating to dependency loops etc.

Each application is expected to include a ``CMakeLists.txt`` file. Each module is expected to
contain a ``lib_build_info.cmake`` file.  These files configure the use of XCommon CMake.

.. code-block::

    sandbox/
           |-- lib_mod0/
           |           |-- lib_mod0/
           |                       |-- api/
           |                       |-- src/
           |                       |-- lib_build_info.cmake
           |
           |-- lib_mod1/
           |           |-- lib_mod1/
           |                       |-- api/
           |                       |-- src/
           |                       |-- lib_build_info.cmake
           |
           |-- lib_mod2/
           |           |-- lib_mod2/
           |                       |-- api/
           |                       |-- src/
           |                       |-- lib_build_info.cmake
           |
           |-- sw_app0/
           |          |-- app_app0_xcore200/
           |          |                    |-- src/
           |          |                    |-- CMakeLists.txt
           |          |-- app_app0_xcoreai/
           |                              |-- src/
           |                              |-- CMakeLists.txt
           |
           |-- sw_app1/
           |          |-- app_app1/
           |                      |-- src/
           |                      |-- CMakeLists.txt
           |

In this example sandbox, ``sw_app0`` and ``sw_app1`` could be unrelated applications which
share some common module dependencies. This layout would allow an engineer to develop and
test multiple applications with a set of shared modules including some local modifications,
without having to replicate those changes across multiple sandboxes.

