# support for eCos http://ecos.sourceware.org
SET(CMAKE_SHARED_LIBRARY_C_FLAGS "")            # -pic 
SET(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "")       # -shared
SET(CMAKE_SHARED_LIBRARY_LINK_C_FLAGS "")         # +s, flag for exe link to use shared lib
SET(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG "")       # -rpath
SET(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP "")   # : or empty

SET(CMAKE_LINK_LIBRARY_SUFFIX "")
SET(CMAKE_STATIC_LIBRARY_PREFIX "lib")
SET(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
SET(CMAKE_SHARED_LIBRARY_PREFIX "lib")          # lib
SET(CMAKE_SHARED_LIBRARY_SUFFIX ".a")           # .a
SET(CMAKE_EXECUTABLE_SUFFIX ".elf")             # same suffix as if built using UseEcos.cmake
SET(CMAKE_DL_LIBS "" )

SET(CMAKE_FIND_LIBRARY_PREFIXES "lib")
SET(CMAKE_FIND_LIBRARY_SUFFIXES ".a")


INCLUDE(Platform/UnixPaths)

# eCos can be built only with gcc
IF(CMAKE_C_COMPILER AND NOT  "${CMAKE_C_COMPILER_ID}" MATCHES "GNU")
  MESSAGE(FATAL_ERROR "GNU gcc is required for eCos")
ENDIF(CMAKE_C_COMPILER AND NOT  "${CMAKE_C_COMPILER_ID}" MATCHES "GNU")
IF(CMAKE_CXX_COMPILER AND NOT  "${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU")
  MESSAGE(FATAL_ERROR "GNU gcc is required for eCos")
ENDIF(CMAKE_CXX_COMPILER AND NOT  "${CMAKE_CXX_COMPILER_ID}" MATCHES "GNU")

# this is a header which is part of every eCos "installation"
# it would be better to search for libtarget.a, but this isn't possible 
# at this point in the setup process, since CMAKE_SIZEOF_VOID_P is still
# unknown, which is used in FIND_LIBRARY()
FIND_PATH(ECOS_SYSTEM_CONFIG_HEADER_PATH NAMES pkgconf/system.h)

IF(NOT ECOS_SYSTEM_CONFIG_HEADER_PATH)
  MESSAGE(FATAL_ERROR "Could not find eCos pkgconf/system.h. Build eCos first and set up CMAKE_FIND_ROOT_PATH correctly.")
ENDIF(NOT ECOS_SYSTEM_CONFIG_HEADER_PATH)

GET_FILENAME_COMPONENT(ECOS_LIBTARGET_DIRECTORY "${ECOS_SYSTEM_CONFIG_HEADER_PATH}" PATH)
SET(ECOS_LIBTARGET_DIRECTORY "${ECOS_LIBTARGET_DIRECTORY}/lib")

# special link commands for eCos executables
SET(CMAKE_CXX_LINK_EXECUTABLE  "<CMAKE_CXX_COMPILER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> -nostdlib -nostartfiles -L${ECOS_LIBTARGET_DIRECTORY} -Ttarget.ld  <LINK_LIBRARIES>")
SET(CMAKE_C_LINK_EXECUTABLE    "<CMAKE_C_COMPILER>   <FLAGS> <CMAKE_C_LINK_FLAGS>   <LINK_FLAGS> <OBJECTS> -o <TARGET> -nostdlib -nostartfiles -L${ECOS_LIBTARGET_DIRECTORY} -Ttarget.ld  <LINK_LIBRARIES>")

# eCos doesn't support shared libs
SET_PROPERTIES(GLOBAL PROPERTIES TARGET_SUPPORTS_SHARED_LIBS FALSE)

SET(CMAKE_CXX_LINK_SHARED_LIBRARY )
SET(CMAKE_CXX_LINK_MODULE_LIBRARY )
SET(CMAKE_C_LINK_SHARED_LIBRARY )
SET(CMAKE_C_LINK_MODULE_LIBRARY )

