# Finds the xerces-c library
# Copyright © 2005-2009 Swiss Tropical Institute and Liverpool School Of Tropical Medicine
# Licence: GNU General Public Licence version 2 or later (see COPYING)
#
# Defines:
# XERCESC_LIBRARIES

FIND_PATH(XERCESC_INCLUDE_DIRS xercesc/dom/DOMNode.hpp
/usr/local/include
/usr/include
)

find_library (XERCESC_LIB NAMES xerces-c xerces-c_3 xerces-c_2 xerces-c_static xerces-c_static_3 xerces-c_static_2
)
if (NOT XERCESC_LIB)
message (FATAL_ERROR "Unable to find xerces-c library")
endif (NOT XERCESC_LIB)
if (NOT XERCESC_INCLUDE_DIRS)
message (FATAL_ERROR "Unable to find xsd include files (xsd/cxx/parser/elements.hxx)")
endif (NOT XERCESC_INCLUDE_DIRS)

SET (XERCESC_LIBRARIES ${XERCESC_LIB})

MARK_AS_ADVANCED(
XERCESC_LIB
XERCESC_LIBRARIES
XERCESC_INCLUDE_DIRS
)

