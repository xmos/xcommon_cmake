set(LIB_NAME lib_static1)
set(LIB_VERSION 1.0.0)

### Items used to build archives contained in this lib
set(LIB_ARCHIVES static1_archive)
set(LIB_ARCHIVE_ARCHS_static1_archive xs2a xs3a)

### Items to allow use of this lib (contained archives and additonal source files)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

XMOS_REGISTER_STATIC_LIB()
