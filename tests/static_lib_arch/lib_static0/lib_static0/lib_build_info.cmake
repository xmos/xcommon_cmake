set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)

### Items for building archives contained in this lib
set(LIB_ARCHIVES static0_archive)
set(LIB_ARCHIVE_ARCHS_static0_archive xs2a xs3a)
set(LIB_ARCHIVE_INCLUDES api)

### Items to allow use of this lib (and contained archives)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

XMOS_REGISTER_STATIC_LIB()
