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

To resolve this error, ensure that the SSH agent is running and, if the SSH key has a passphrase,
that the key has been added to the agent. On Windows, the OpenSSH agent service is not started by
default; the following PowerShell command sets it to start automatically and starts it now:

.. code-block:: powershell

    Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service

(The ``-PassThru`` flag only passes the service object along the pipeline so that the two
operations can be written as one command; it does not affect whether the agent starts.)

If the error persists with the agent running, be aware that on Windows there can be more than one
installation of ``ssh``: Git for Windows uses its own bundled ``ssh`` by default, which is not
necessarily the one found on ``PATH``, and the two may be talking to different SSH agents. A key
loaded into the Windows ``ssh-agent`` service can therefore still be invisible to ``git``. To see
whether this is the case, compare the following two commands:

.. code-block:: powershell

    ssh -o BatchMode=yes git@github.com
    git ls-remote git@github.com:xmos/lib_i2c

If the first authenticates but the second is denied, ``git`` is using a different ``ssh``. Setting
the ``GIT_SSH_COMMAND`` environment variable, or the ``core.sshCommand`` git option, controls which
``ssh`` git uses. Alternatively, configure with ``-D DEPS_PROTOCOL=https`` to fetch public
dependencies over HTTPS without using SSH at all; see :ref:`cmdline-options`.

Then the CMake command can be re-run.

Project always rebuilds on Windows
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

 When running the build step (`xmake`) on Windows a rebuild may always occur even if no changes
 have been made. This is due to an underlying issue in the `XMOS` preprocessor (XPP). The
 current recommended work around is to install XTC tools on a path that does not include any
 spaces (i.e. not in the default `Program Files` location).

xmake fails in Git Bash on Windows when the XTC Tools path contains parentheses
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

When running ``xmake`` from Git Bash on Windows, the build can fail if the XTC Tools are installed
in a path containing parentheses, such as the default ``C:\Program Files (x86)\XMOS`` location.
This is caused by how GNU Make handles its internal ``MAKE`` variable when the path to the make
executable contains shell-special characters.

To work around this, override the ``MAKE`` variable when running the build so that recursive make
invocations resolve ``xmake`` from ``PATH`` instead of using the full path containing parentheses:

.. code-block:: console

    xmake MAKE=xmake

Alternatively, run the build from the XTC Tools Command Prompt or install the XTC Tools in a path
that does not contain parentheses.
