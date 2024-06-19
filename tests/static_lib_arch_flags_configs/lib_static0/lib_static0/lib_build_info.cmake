set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)

### Items used to build archives contained in this lib

# Specify "configs" for the archives we want to build
set(LIB_ARCHIVES static0_archive0 static0_archive1)

# For each "config" specify the architectures to build archives for
set(LIB_ARCHIVE_ARCHS_static0_archive0 xs2a xs3a)
set(LIB_ARCHIVE_ARCHS_static0_archive1 xs3a)

# For each archive "config" provide some options that apply to building the .a
set(LIB_ARCHIVE_FLAGS_static0_archive0 -DLIB_STATIC0_OPTION_archive0=1)
set(LIB_ARCHIVE_FLAGS_static0_archive1 -DLIB_STATIC0_OPTION_archive1=1)

# Dependencies for this lib
## TODO This is unclear - is this used when building the archive or for the additional source files (or both)?
# It appears to to be the former, so should be LIB_ARCHIVE_DEPENDENT_MODULES?
# Are both useful features?
set(LIB_DEPENDENT_MODULES "")

### Items to allow use of this lib (contained archives and additonal source files)

# Include directory to expose to the dependent lib/app
set(LIB_INCLUDES api)

# Compiler options to apply to the additional source files (i.e. source files not compiled into .a)
set(LIB_COMPILER_FLAGS -DLIB_STATIC0_OPTION=1)

XMOS_REGISTER_STATIC_LIB()
