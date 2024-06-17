set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)
set(LIB_ARCH xs3a xs2a)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

set(LIB_ADD_SRC_DIRS src)
set(LIB_ADD_INC_DIRS inc)

# Applies to building the .a
set(LIB_COMPILER_FLAGS_xs3a -DLIB_STATIC0_OPTION_xs3a=1)

# Applies to the additional source files
set(LIB_COMPILER_FLAGS -DLIB_STATIC0_OPTION=1)

XMOS_REGISTER_STATIC_LIB()
