Troubleshooting Common Issues
-----------------------------

.. contents::
    :local:
    :class: this-will-duplicate-information-and-it-is-still-useful-here

CMake error: include could not find requested file
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When running the CMake command, the following error occurs:

.. code-block:: console

    CMake Error at CMakeLists.txt:2 (include):
      include could not find requested file:

        /xcommon.cmake

This error occurs when the CMake command is run without having the XTC Tools loaded in the
current environment.

To resolve this error, first delete the build directory and then follow the instructions in
the XTC user guide to configure the tools environment. The CMake command can then be re-run.

CMake error: CMAKE_MAKE_PROGRAM is not set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When running the CMake command, the following error occurs:

.. code-block:: console

    CMake Error: CMake was unable to find a build program corresponding to "Unix Makefiles".  CMAKE_MAKE_PROGRAM is not set.  You probably need to select a different build tool.

The error can occur if the CMake command is initially run in an incorrectly configured
environment where there is no program available to build Unix Makefiles.

To resolve this error, first delete the build directory and ensure that the XTC Tools environment
is configured correctly. Then the CMake command can be re-run.

Cannot set -Xmapper compiler options
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

With legacy XCommon Makefiles, the option ``-Xmapper --map -Xmapper MAPFILE`` can be added to
the ``XCC_FLAGS`` to generate a mapfile; adding this to the ``APP_COMPILER_FLAGS`` variable
in an XCommon CMake application will give the following error when running ``xmake``:

.. code-block:: console

    xcc: MAPFILE: No such file or directory

The problem is that CMake de-duplicates the list of compiler options, so the second ``-Xmapper``
is removed and the option combination is no longer valid. The ``SHELL:`` prefix avoids this
behaviour, so a mapfile can be generated using these options by specifying them in this way:

.. code-block:: cmake

    set(APP_COMPILER_FLAGS "SHELL:-Xmapper --map" "SHELL:-Xmapper MAPFILE")

Fail to clone dependency repository
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When running the CMake command, dependency repositories fail to clone with the following error:

.. code-block:: console

    Cloning into '<repository-name>'...
    git@github.com: Permission denied (publickey).
    fatal: Could not read from remote repository.

    Please make sure you have the correct access rights
    and the repository exists.

To resolve this error, ensure that the SSH agent is running and, if the SSH key has a password
that it has been unlocked. Then the CMake command can be re-run.

Project always rebuilds on Windows
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When running the build step (`xmake`) on Windows a rebuild may always occur even if no changes 
have been made. This is due to an underlying issue in the `XMOS` preprocessor (XPP). The 
current recommended work around is to install XTC tools on a path that does not include any 
spaces (i.e. not in the default `Program Files` location). 


