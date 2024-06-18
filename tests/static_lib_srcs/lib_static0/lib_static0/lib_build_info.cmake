set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)

set(LIB_ARCHIVES static0_archive)
set(LIB_ARCHIVE_ARCHS_static0_archive xs3a)

set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

# By default expect xcommon to use ./libsrc for archive src files
# By default expect xcommon to use ./src for additional src files
#set(LIB_ADD_SRC_DIRS src)
#set(LIB_ADD_INC_DIRS inc)

XMOS_REGISTER_STATIC_LIB()
