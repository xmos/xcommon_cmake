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
