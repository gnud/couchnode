MACRO(TRANSFORM_TARGET tname output_pdb output_exp)
    # Base extension name
    GET_FILENAME_COMPONENT(_base "${tname}" NAME_WE)
    GET_FILENAME_COMPONENT(_type "${tname}" EXT)

    # Path, e.g. 'Debug'
    GET_FILENAME_COMPONENT(_bindir "${tname}" PATH)
    GET_FILENAME_COMPONENT(_config "${_bindir}" NAME)

    # e.g. the build directory itself
    IF(CMAKE_BUILD_TYPE)
        GET_FILENAME_COMPONENT(_basedir "${_bindir}/../" ABSOLUTE)
        SET(_config "")
    ELSE()
        GET_FILENAME_COMPONENT(_basedir "${_bindir}/../../" ABSOLUTE)
    ENDIF()

    SET(${output_pdb} "${_basedir}/bin/${_config}/${_base}.pdb")
    IF( ".dll" STREQUAL "${_type}")
        SET(${output_exp} "${_basedir}/lib/${_config}/${_base}.exp")
    ENDIF()
ENDMACRO()

MACRO(INSTALL_PDBS target)
    IF(MSVC)
        GET_TARGET_PROPERTY(_BIN_DEBUG ${target} LOCATION_DEBUG)
        GET_TARGET_PROPERTY(_BIN_RDB ${target} LOCATION_RelWithDebInfo)
        TRANSFORM_TARGET(${_BIN_DEBUG} _DEBUG_PDB _DEBUG_EXP)
        TRANSFORM_TARGET(${_BIN_RDB} _RDB_PDB _RDB_EXP)
        INSTALL(FILES ${_DEBUG_PDB} DESTINATION bin CONFIGURATIONS DEBUG)
        INSTALL(FILES ${_RDB_PDB} DESTINATION bin CONFIGURATIONS RelWithDebInfo)
        IF(_DEBUG_EXP)
            INSTALL(FILES ${_DEBUG_EXP} DESTINATION lib CONFIGURATIONS DEBUG)
        ENDIF()
        IF(_RDB_EXP)
            INSTALL(FILES ${_RDB_EXP} DESTINATION lib CONFIGURATIONS RelWithDebInfo)
        ENDIF()
    ENDIF(MSVC)
ENDMACRO()
