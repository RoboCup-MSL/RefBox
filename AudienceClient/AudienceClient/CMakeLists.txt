INCLUDE( ${QT_USE_FILE} )
INCLUDE( ${VTK_USE_FILE} )

INCLUDE_DIRECTORIES(
	.
	../config/
	${CMAKE_CURRENT_BINARY_DIR}
)

SET( AUDIENCECLIENT_SRCS 
	ConfigXML.cpp FieldWidget3D.cpp main.cpp mainwindow.cpp Param.cpp  ../config/field.conf.cxx controlpanel.cpp
)

# another list, this time it includes all header files that should be treated with moc
SET( AUDIENCECLIENT_MOC_HDRS
	ConfigXML.h FieldWidget3D.h mainwindow.h Param.h ../config/field.conf.hxx  Team.h controlpanel.h
)

# some .ui files
SET( AUDIENCECLIENT_UIS
	mainwindow.ui
	controlpanel.ui
)

QT4_WRAP_UI( AUDIENCECLIENT_UI_HDRS ${AUDIENCECLIENT_UIS} ) #Generate headers using QT UI files
QT4_WRAP_CPP( AUDIENCECLIENT_MOC_SRCS ${AUDIENCECLIENT_MOC_HDRS} ) #Generate CPP files from moh headers

ADD_EXECUTABLE( audienceClient
 ${AUDIENCECLIENT_SRCS} 
 ${AUDIENCECLIENT_MOC_SRCS} 
 ${AUDIENCECLIENT_UI_HDRS} 
)

TARGET_LINK_LIBRARIES( audienceClient 
 ${QT_LIBRARIES}
 ${XERCESC_LIBRARIES}
 QVTK
 vtkRendering 
 vtkGraphics 
 vtkCommon 
 vtkIO 
 vtkFiltering 
 vtkHybrid
 qjson
)

