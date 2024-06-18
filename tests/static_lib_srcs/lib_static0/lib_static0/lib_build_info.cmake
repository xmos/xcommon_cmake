set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)

set(LIB_ARCHIVES static0_archive)
set(LIB_ARCHIVE_ARCHS_static0_archive xs3a)

# Includes to export for user of the lib
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

# By default expect xcommon to use ./libsrc for archive src files
# By default expect xcommon to use ./src for additional src files

# Includes for building the archive(s)
set(LIB_ARCHIVE_INCLUDES inc)

XMOS_REGISTER_STATIC_LIB()
