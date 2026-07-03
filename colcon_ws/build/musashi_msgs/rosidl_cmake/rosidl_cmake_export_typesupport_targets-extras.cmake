# generated from
# rosidl_cmake/cmake/template/rosidl_cmake_export_typesupport_targets.cmake.in

set(_exported_typesupport_targets
  "__rosidl_generator_c:musashi_msgs__rosidl_generator_c;__rosidl_typesupport_fastrtps_c:musashi_msgs__rosidl_typesupport_fastrtps_c;__rosidl_typesupport_introspection_c:musashi_msgs__rosidl_typesupport_introspection_c;__rosidl_typesupport_c:musashi_msgs__rosidl_typesupport_c;__rosidl_generator_cpp:musashi_msgs__rosidl_generator_cpp;__rosidl_typesupport_fastrtps_cpp:musashi_msgs__rosidl_typesupport_fastrtps_cpp;__rosidl_typesupport_introspection_cpp:musashi_msgs__rosidl_typesupport_introspection_cpp;__rosidl_typesupport_cpp:musashi_msgs__rosidl_typesupport_cpp;__rosidl_generator_py:musashi_msgs__rosidl_generator_py")

# populate musashi_msgs_TARGETS_<suffix>
if(NOT _exported_typesupport_targets STREQUAL "")
  # loop over typesupport targets
  foreach(_tuple ${_exported_typesupport_targets})
    string(REPLACE ":" ";" _tuple "${_tuple}")
    list(GET _tuple 0 _suffix)
    list(GET _tuple 1 _target)

    set(_target "musashi_msgs::${_target}")
    if(NOT TARGET "${_target}")
      # the exported target must exist
      message(WARNING "Package 'musashi_msgs' exports the typesupport target '${_target}' which doesn't exist")
    else()
      list(APPEND musashi_msgs_TARGETS${_suffix} "${_target}")
    endif()
  endforeach()
endif()
