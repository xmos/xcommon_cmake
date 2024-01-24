set(LIB_NAME lib_mod0)
set(LIB_VERSION 1.0.0)
set(LIB_INCLUDES api)
set(LIB_DEPENDENT_MODULES "")

XMOS_REGISTER_MODULE()

add_custom_target(mod0_generated.c
                  ${CMAKE_COMMAND} -E echo \"void mod0_generated() {}\" > ${CMAKE_BINARY_DIR}/mod0_generated.c
                  BYPRODUCTS ${CMAKE_BINARY_DIR}/mod0_generated.c
                 )

foreach(_target ${APP_BUILD_TARGETS})
    target_sources(${_target} PRIVATE ${CMAKE_BINARY_DIR}/mod0_generated.c)
endforeach()
