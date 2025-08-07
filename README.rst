#############
xcommon_cmake
#############

CMake-based build system for `XMOS xcore` applications.

`xcommon_cmake` is bundled with XTC from version **15.3.0** onwards.

***********************
Bundled Versions in XTC
***********************

+----------------+-------------------+
| XTC Version    | xcommon_cmake     |
+================+===================+
| 15.3.0         | 1.3.0             |
+----------------+-------------------+
| 15.3.1         | 1.3.0             |
+----------------+-------------------+

********
Updating
********

To update the version of `xcommon_cmake` used in your XTC installation,
copy the following files from this repository to your local XTC install at:

::

  <XTC_INSTALL_PATH>/build/xcommon_cmake

Files to update:

* ``Compiler/XCC-ASM.cmake``
* ``xc_override.cmake``
* ``xcommon.cmake``
* ``xcore_xs.cmake``
