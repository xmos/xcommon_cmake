set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)

### Items to allow use of this lib (contained archives and additonal source files)

set(LIB_ARCHIVES static0_archive)
set(LIB_ARCHIVE_ARCHS_static0_archive xs3a)
set(LIB_DEPENDENT_MODULES "")
# Includes for building the archive(s)
set(LIB_ARCHIVE_INCLUDES inc)

# By default expect xcommon to use ./libsrc for archive src files

### Items to allow use of this lib (contained archives and additonal source files)

# Includes to export for user of the lib
set(LIB_INCLUDES api)

# By default expect xcommon to use ./src for additional src files

XMOS_REGISTER_STATIC_LIB()
