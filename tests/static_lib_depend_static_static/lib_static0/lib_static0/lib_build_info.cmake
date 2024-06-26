set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)

### Items used to build archives contained in this lib
set(LIB_ARCHIVES static0_archive)
set(LIB_ARCHIVE_ARCHS_static0_archive xs2a xs3a)
set(LIB_ARCHIVE_INCLUDES api)
set(LIB_ARCHIVE_DEPENDENT_MODULES lib_static1)

### Items to allow use of this lib (contained archives and additonal source files)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES lib_static1)

set(XMOS_SANDBOX_DIR ${CMAKE_CURRENT_LIST_DIR}/../..)

XMOS_REGISTER_STATIC_LIB()
