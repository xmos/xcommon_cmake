Dependency Management
---------------------

XCommon CMake provides a dependency management solution which can fetch modules to be used in an
application. These modules are cloned from git repositories and placed in the root of the sandbox.

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

Whenever CMake generates the build environment for an application or static library, a file called ``manifest.txt``
is created in the ``build`` directory.

The columns in the manifest file are:

- Name: the name of the application or library
- Location: the git remote from which the repository was cloned
- Branch/tag: the currently checked out branch or tag. A tag takes precedence, so if the head of a branch is explicitly
  checked out, but that changeset has also been tagged, then the tag will be reported here.
- Changeset: the git commit hash identifying the current changeset checked out in the repository
- Dependency_Requirement: (hidden) the requirement for the repository from the dependent modules list variable. This can
  differ from the current changeset if the developer has manually checked out a different version of that component. This
  column is only displayed if CMake is run with the option ``-D FULL_MANIFEST=TRUE``.

If any columns are not applicable to a particular dependency, they will contain a hyphen.
