#
MACRO(YASMIFY)
ENDMACRO(YASMIFY)
IF(ADM_CPU_X86 )
    MESSAGE(STATUS "Checking for YASM")
    MESSAGE(STATUS "*****************")
    FIND_PROGRAM(YASM_YASM yasm)
    IF(YASM_YASM STREQUAL "<YASM_YASM>-NOTFOUND")
        MESSAGE(FATAL_ERROR "Yasm Not found. Stopping here.")
    ENDIF(YASM_YASM STREQUAL "<YASM_YASM>-NOTFOUND")
    MESSAGE(STATUS "Found as ${YASM_YASM}")

    SET(ASM_DIALECT "_NASM")

    SET(CMAKE_ASM_SOURCE_FILE_EXTENSIONS nasm;nas;asm)
    ENABLE_LANGUAGE(ASM_NASM)
    SET(CMAKE_ASM_NASM_COMPILER ${YASM_YASM})
    SET(ASM_ARGS "")
    IF(APPLE)
            SET(ASM_ARGS_FORMAT  "-f macho64 -DPREFIX")
    ELSE(APPLE)
      IF(WIN32)
        IF(ADM_CPU_X86_64)
            SET(ASM_ARGS_FORMAT  "-f win64")
        ELSE(ADM_CPU_X86_64)
            SET(ASM_ARGS_FORMAT  "-f win32 ")
        ENDIF(ADM_CPU_X86_64)
      ELSE(WIN32) # Linux
        SET(ASM_ARGS_FORMAT      "-f elf -DPIC")
      ENDIF(WIN32)
    ENDIF(APPLE)

    IF(WIN32 AND NOT ADM_CPU_X86_64)
        SET(ASM_ARGS_FLAGS       "-DHAVE_ALIGNED_STACK=0 -DPREFIX")
    ELSE(WIN32 AND NOT ADM_CPU_X86_64)
        SET(ASM_ARGS_FLAGS       "-DHAVE_ALIGNED_STACK=1")
    ENDIF(WIN32 AND NOT ADM_CPU_X86_64)

      
     
    IF( ADM_CPU_X86_64 )
        SET(ASM_ARGS_FORMAT "${ASM_ARGS_FORMAT} -m amd64 -DARCH_X86_64=1")
    ELSE( ADM_CPU_X86_64 )
        SET(ASM_ARGS_FORMAT "${ASM_ARGS_FORMAT}  -DARCH_X86_64=0")
    ENDIF( ADM_CPU_X86_64 )
    
    SET(ASM_ARGS_FLAGS "${ASM_ARGS_FLAGS} -DHAVE_CPUNOP=0") # Not sure what this is for ?

   IF(AVIDEMUX_THIS_IS_CORE)
        SET(NASM_MACRO_FOLDER  ${AVIDEMUX_TOP_SOURCE_DIR}/avidemux_core/ADM_core/include)
   ELSE(AVIDEMUX_THIS_IS_CORE)
        SET(NASM_MACRO_FOLDER  ${ADM_HEADER_DIR}/ADM_core/include)
   ENDIF(AVIDEMUX_THIS_IS_CORE)


    

    if (CMAKE_BUILD_TYPE STREQUAL "Debug")
        SET(ASM_ARGS_FLAGS "${ASM_ARGS_FLAGS} -gdwarf2")
    endif (CMAKE_BUILD_TYPE STREQUAL "Debug")
    
    SET(CMAKE_ASM_NASM_FLAGS "${ASM_ARGS_FORMAT} ${ASM_ARGS_FLAGS} -I${NASM_MACRO_FOLDER}" CACHE INTERNAL "" )

    
    INCLUDE(CMakeASMInformation)
    SET( CMAKE_ASM_NASM_COMPILE_OBJECT  "<CMAKE_ASM_NASM_COMPILER> ${CMAKE_ASM_NASM_FLAGS} -o <OBJECT> <SOURCE>" CACHE INTERNAL "")

#
#
#get_cmake_property(_variableNames VARIABLES)
#foreach (_variableName ${_variableNames})
    #message(STATUS "${_variableName}=${${_variableName}}")
#endforeach()

ELSE(ADM_CPU_X86 )
    MESSAGE(STATUS "Not X86, no need for yasm")
ENDIF(ADM_CPU_X86 ) # Temp hack
