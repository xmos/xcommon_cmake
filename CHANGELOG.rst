XCommon CMake Change Log
========================

UNRELEASED
----------

  * ADDED: support for fetching dependencies that are static libraries
  * CHANGED: supported repository structure for static libraries
  * FIXED: xpca response file erroneously deleted
  * FIXED: PCA commands fail if there are spaces in the directory path
  * FIXED: PCA failures when building C++ sources
  * FIXED: modifying XN file doesn't cause an application rebuild

0.2.0
-----

  * ADDED: warning if LIB_NAME variable doesn't match module directory name
  * FIXED: APP_BUILD_TARGETS variable wasn't available until XMOS_REGISTER_APP returned

0.1.0
-----

  * Initial release
