Multi-Application Repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Repository ``sw_multiapp`` contains two applications, which have a shared dependency and a
unique dependency each. Application ``app_multiapp0`` requires modules ``lib_mod0`` and
``lib_mod1``; application ``app_multiapp1`` requires modules ``lib_mod0`` and ``lib_mod2``.

Directory structure
"""""""""""""""""""

.. code-block::

    sandbox/
           |-- lib_mod0/
           |           |-- lib_mod0/
           |                       |-- api/
           |                       |-- lib_build_info.cmake
           |                       |-- src/
           |-- lib_mod1/
           |           |-- lib_mod1/
           |                       |-- api/
           |                       |-- lib_build_info.cmake
           |                       |-- src/
           |-- lib_mod2/
           |           |-- lib_mod2/
           |                       |-- api/
           |                       |-- lib_build_info.cmake
           |                       |-- src/
           |-- sw_multiapp/
                          |-- app_multiapp0/
                          |                |-- CMakeLists.txt
                          |                |-- src/
                          |-- app_multiapp1/
                          |                |-- CMakeLists.txt
                          |                |-- src/
                          |-- CMakeLists.txt
                          |-- deps.cmake

CMake file contents
"""""""""""""""""""

`sandbox/sw_multiapp/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(sw_multiapp)

    add_subdirectory(app_multiapp0)
    add_subdirectory(app_multiapp1)

`sandbox/sw_multiapp/deps.cmake`

.. code-block:: cmake

    set(APP_DEPENDENT_MODULES "lib_mod0"
                              "lib_mod1"
                              "lib_mod2")

`sandbox/sw_multiapp/app_multiapp0/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(multiapp0)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)
    include(${CMAKE_CURRENT_LIST_DIR}/../deps.cmake)
    set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)

    XMOS_REGISTER_APP()

`sandbox/sw_multiapp/app_multiapp0/src/main.c`

.. code-block:: c

    #include "mod0.h"
    #include "mod1.h"

    int main() {
        mod0();
        mod1();
        return 0;
    }

`sandbox/sw_multiapp/app_multiapp1/CMakeLists.txt`

.. code-block:: cmake

    cmake_minimum_required(VERSION 3.21)
    include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
    project(multiapp1)

    set(APP_HW_TARGET XCORE-AI-EXPLORER)
    include(${CMAKE_CURRENT_LIST_DIR}/../deps.cmake)
    set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)

    XMOS_REGISTER_APP()

`sandbox/sw_multiapp/app_multiapp1/src/main.c`

.. code-block:: c

    #include "mod0.h"
    #include "mod2.h"

    int main() {
        mod0();
        mod2();
        return 0;
    }

`sandbox/lib_mod0/lib_mod0/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_mod0)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()

`sandbox/lib_mod1/lib_mod1/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_mod1)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()

`sandbox/lib_mod2/lib_mod2/lib_build_info.cmake`

.. code-block:: cmake

    set(LIB_NAME lib_mod2)
    set(LIB_VERSION 1.0.0)
    set(LIB_INCLUDES api)
    set(LIB_DEPENDENT_MODULES "")

    XMOS_REGISTER_MODULE()


Build instructions
""""""""""""""""""

Commands to build and run both applications, from working directory ``sandbox/sw_multiapp``:

.. code-block:: console

    cmake -G "Unix Makefiles" -B build
    cd build
    xmake

The build products are ``app_multiapp0/bin/multiapp0.xe`` and ``app_multiapp1/bin/multiapp1.xe``.

Alternatively, a single application can be configured and built. From working directory
``sandbox/sw_multiapp/app_multiapp1``:

.. code-block:: console

    cmake -G "Unix Makefiles" -B build
    cd build
    xmake

The build product is ``bin/multiapp1.xe``. Application ``app_multiapp0`` has not been built.

Best practice
"""""""""""""

For a repository which contains multiple applications, each with different dependencies, if each
has its own definition of the ``APP_DEPENDENT_MODULES`` variable, trying to keep the common
dependencies synchronised is error-prone.

In a multi-application repository, ``cmake`` can configure and generate the build environment at
different levels: either for a single application from within that application's subdirectory, or
for all applications from the ``CMakeLists.txt`` file in the root of the repository. For simplicity,
it is preferable for the manifest to show a common view of the whole sandbox, rather than only
reporting the dependencies in the sandbox which are used by a single application.

Therefore, it is strongly recommended to set the ``APP_DEPENDENT_MODULES`` variable with the full
list of dependencies for all applications in the repository in the common ``deps.cmake`` file, as
in the example above. Individual applications should not modify the ``APP_DEPENDENT_MODULES`` variable
in their own ``CMakeLists.txt`` files, otherwise the generated manifest file may be incorrect.
