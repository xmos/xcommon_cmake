set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)

### Items used to build archives contained in this lib

# Note, no "configs" listed for the archives

# Specify architectures to build archives for
set(LIB_ARCHIVE_ARCHS xs2a xs3a)

# Specify dependencies required to build archives
set(LIB_ARCHIVE_DEPENDENT_MODULES "")

# Specify includes for building archives
set(LIB_ARCHIVES_INCLUDES api)

### Items used to build archives contained in this lib

# Include directory to expose to the dependent libs/apps
set(LIB_INCLUDES api)

XMOS_REGISTER_STATIC_LIB()
