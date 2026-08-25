.. _cmdline-options:

Command-line Options
--------------------

Extra functionality can be activated using command-line options which are implemented in XCommon
CMake. These are passed to the CMake command via its ``-D`` option, and multiple options can be
provided to a single CMake command if required:

.. code-block:: console

  cmake -G "Unix Makefiles" -B build -D <option0>=<value0> -D <option1>=<value1>

Supported options
^^^^^^^^^^^^^^^^^

``BUILD_NATIVE``
  Boolean option to configure the build for the native host CPU rather than an xcore target. See
  :ref:`native-builds` for more details about this feature. Example:

  .. code-block:: console

    cmake -G "Unix Makefiles" -B build -D BUILD_NATIVE=ON

``DEPS_CLONE_SHALLOW``
  Boolean option to perform a shallow clone of all missing dependencies. The git repository for
  each dependency will be cloned as a single commit, rather than the complete history. This can
  reduce the disk usage, but if the full git history is later required, it will need to be
  fetched manually. Example:

  .. code-block:: console

    cmake -G "Unix Makefiles" -B build -D DEPS_CLONE_SHALLOW=TRUE

``STRICT_VERSIONING``
  Boolean option to fail the build when a dependency pinned to a release version is not checked out
  at that version. For each declaration which names a three-part version, the release tag checked
  out in the module's git repository must match it exactly; the major, minor and patch components
  must all be equal. This is a stronger check than the ``LIB_VERSION`` comparison described in
  :ref:`version-checking`, which examines only the major component and only the version that a
  module declares for itself.

  A declaration which names a branch or a commit, or which gives no version, is not checked, because
  there is no version to compare against.

  A module whose version cannot be determined is treated as a failure rather than allowed to pass.
  This includes a module which is checked out on a branch or at an untagged commit, and one whose
  directory is not a git repository at all.

  The option is disabled by default. Example:

  .. code-block:: console

    cmake -G "Unix Makefiles" -B build -D STRICT_VERSIONING=ON
