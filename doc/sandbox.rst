Sandbox Structure
-----------------

A sandbox is a collection of source code repositories which can be used to build one or
more applications.

Definitions
^^^^^^^^^^^

There are three types of top-level directories that are present in a sandbox.

Application
  Contains source code that is specific to the application, and can depend on modules.

Module
  Contains module source code, which can depend on other modules. Module code is compiled
  into objects which are directly linked into the application binary.

Static Library
  Contains source code and (optionally) a pre-built static library archive, which can be
  linked into the application binary.

Repo Layout
^^^^^^^^^^^

All the source code repositories are placed in the root of the sandbox; there is no nesting
of applications and modules. Each directory in the sandbox is a separate git repository.

.. code-block::

    sandbox/
           |-- lib_mod0/
           |           |-- lib_mod0/
           |                       |-- api/
           |                       |-- src/
           |
           |-- lib_mod1/
           |           |-- lib_mod1/
           |                       |-- api/
           |                       |-- src/
           |
           |-- lib_mod2/
           |           |-- lib_mod2/
           |                       |-- api/
           |                       |-- src/
           |
           |-- sw_app0/
           |          |-- app_app0_xcore200/
           |          |                    |-- src/
           |          |-- app_app0_xcoreai/
           |                              |-- src/
           |
           |-- sw_app1/
           |          |-- app_app1/
           |                      |-- src/
           |

In this example sandbox, ``sw_app0`` and ``sw_app1`` could be unrelated applications which
share some common module dependencies. This layout would allow an engineer to develop and
test multiple applications with a set of shared modules including some local modifications,
without having to replicate those changes across multiple sandboxes.
