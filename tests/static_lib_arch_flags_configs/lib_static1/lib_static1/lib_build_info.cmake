set(LIB_NAME lib_static1)
set(LIB_VERSION 1.0.0)

### Items used to build archives contained in this lib

# Specify architectures to build archives for
set(LIB_ARCHIVE_ARCHS xs2a xs3a)

# Provide some options that apply to building the .a
set(LIB_ARCHIVE_FLAGS -DLIB_STATIC1_OPTION_archive=1)

# Depencencies used to build archive
# TODO rename?
set(LIB_DEPENDENT_MODULES "")

# Specify includes for building archives
set(LIB_INCLUDES api inc)

### Items to allow use of this lib (contained archives and additonal source files)

# Include directory to expose to the dependent lib/app
set(LIB_INCLUDES api)

# Compiler options to apply to the additional source files (i.e. source files not compiled into .a)
set(LIB_COMPILER_FLAGS -DLIB_STATIC1_OPTION=1)

XMOS_REGISTER_STATIC_LIB()
