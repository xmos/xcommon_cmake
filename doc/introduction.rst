Introduction
------------

XCommon CMake is a build system for xcore applications and libraries. It uses ``git`` to
fetch dependencies, followed by ``cmake`` to configure and generate a build environment,
which can then be built with ``ninja``.

The aim of XCommon CMake is to use a standard tool (CMake) to accelerate the development of
xcore applications without requiring knowledge of the CMake language.

The minimum versions of required tools are listed in the :ref:`software-requirements`.

Overview
^^^^^^^^

An application executable is built from separate components: application sources, module sources
and static libraries.

Each component sets some cmake variables to define its own properties and its dependency
relationships with other components.

Then XCommon CMake utility functions provide a CMake implementation to create a build environment
with the properties as defined in the components.

To support this functionality, a sandbox structure is assumed. Within this structure, XCommon
CMake is able to fetch missing dependencies.
