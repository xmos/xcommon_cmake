XCommon CMake Change Log
========================

UNRELEASED
----------

  * ADDED:     Support APP_HW_TARGET paths to XN files outside the application directory (#132)
  * ADDED:     Include .cc files in C++ source glob (#212)
  * ADDED:     Troubleshooting section to documentation
  * ADDED:     LIB_VERSION generates version number compile definitions for library sources (#213)
  * ADDED:     Documentation for using XCOMMON_CMAKE_VER to query the xcommon-cmake version
  * ADDED:     STRICT_VERSIONING option to fail the build when a dependency pinned to a release
               version is not checked out at that version
  * ADDED:     Documentation for the version checking performed during dependency resolution
  * ADDED:     DEPS_PROTOCOL option to force dependencies to be fetched over SSH or HTTPS
  * ADDED:     Documentation for how the dependency fetch protocol is selected
  * FIXED:     SSH access check now uses the same ssh command as git, so the check cannot pass
               while the clone fails (#196)
  * FIXED:     Falling back to HTTPS for dependency fetches is now reported instead of silent (#196)
  * FIXED:     execute_process() failures were ignored
  * FIXED:     APP_COMPILER_FLAGS usage was missing from compiler flags documentation (#218)
  * FIXED:     Duplicate matching XN filenames now report a clear configuration error (#211)

1.3.0
-----

  * ADDED:     DEPS_CLONE_SHALLOW option for performing shallow git clones

1.2.1
-----

  * CHANGED:   xmosdoc v5.5.1 for building documentation

1.2.0
-----

  * ADDED:     Support for multiple prebuilt archives in a static library repository
  * ADDED:     Support for configuring compiler flags on static library additional sources
  * ADDED:     XCOMMON_CMAKE_VER cache variable
  * CHANGED:   Use CONFIGURE_DEPENDS option in all GLOBs such that they are re-run at build-time

1.1.0
-----

  * ADDED:     "Depends on" column in generated manifest file (when FULL_MANIFEST=TRUE)
  * ADDED:     Support for compiling additional sources for a static library
  * ADDED:     Support for default optional header name based on LIB_NAME
  * ADDED:     Support for optional headers with additional sources for a static library
  * CHANGED:   Removed "Dependency_requirement" column in generated manifest file (when FULL_MANIFEST=TRUE)

1.0.0
-----

  * ADDED:     Support for fetching dependencies that are static libraries
  * CHANGED:   Supported repository structure for static libraries
  * FIXED:     xpca response file erroneously deleted
  * FIXED:     PCA commands fail if there are spaces in the directory path
  * FIXED:     PCA failures when building C++ sources
  * FIXED:     modifying XN file doesn't cause an application rebuild

0.2.0
-----

  * ADDED:     Warning if LIB_NAME variable doesn't match module directory name
  * FIXED:     APP_BUILD_TARGETS variable wasn't available until XMOS_REGISTER_APP returned

0.1.0
-----

  * Initial release
