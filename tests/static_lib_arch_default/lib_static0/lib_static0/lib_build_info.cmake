set(LIB_NAME lib_static0)
set(LIB_VERSION 1.0.0)

# Defaults used for building archives contained in this lib
# e.g. arch = xs3a

# Items to allow use of this lib (and contained archive)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

XMOS_REGISTER_STATIC_LIB()
