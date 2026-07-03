cmake_minimum_required (VERSION 2.8)
project (MSLAudienceClient)

SET( BASE_DIR ${CMAKE_SOURCE_DIR} )

# Set output directories for libraries and executables
SET( CMAKE_LIBRARY_OUTPUT_DIRECTORY ${BASE_DIR}/lib )
SET( CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${BASE_DIR}/lib )
SET( CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BASE_DIR}/bin )

# Define where to find modules
SET( CMAKE_MODULE_PATH ${CMAKE_MODULES_PATH} ${BASE_DIR}/CMakeModules )

SET( QT_USE_QTXML TRUE )

find_package(Qt4 REQUIRED COMPONENTS 
	QtCore
	QtNetwork
	QtGui
)

FIND_PACKAGE( XERCESC   REQUIRED )
FIND_PACKAGE( VTK	REQUIRED )

include(${QT_USE_FILE})
INCLUDE (${VTK_USE_FILE})

ADD_SUBDIRECTORY( AudienceClient )

