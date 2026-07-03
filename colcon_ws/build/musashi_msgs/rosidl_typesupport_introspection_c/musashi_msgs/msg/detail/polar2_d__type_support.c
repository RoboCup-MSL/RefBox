// generated from rosidl_typesupport_introspection_c/resource/idl__type_support.c.em
// with input from musashi_msgs:msg/Polar2D.idl
// generated code does not contain a copyright notice

#include <stddef.h>
#include "musashi_msgs/msg/detail/polar2_d__rosidl_typesupport_introspection_c.h"
#include "musashi_msgs/msg/rosidl_typesupport_introspection_c__visibility_control.h"
#include "rosidl_typesupport_introspection_c/field_types.h"
#include "rosidl_typesupport_introspection_c/identifier.h"
#include "rosidl_typesupport_introspection_c/message_introspection.h"
#include "musashi_msgs/msg/detail/polar2_d__functions.h"
#include "musashi_msgs/msg/detail/polar2_d__struct.h"


#ifdef __cplusplus
extern "C"
{
#endif

void musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_init_function(
  void * message_memory, enum rosidl_runtime_c__message_initialization _init)
{
  // TODO(karsten1987): initializers are not yet implemented for typesupport c
  // see https://github.com/ros2/ros2/issues/397
  (void) _init;
  musashi_msgs__msg__Polar2D__init(message_memory);
}

void musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_fini_function(void * message_memory)
{
  musashi_msgs__msg__Polar2D__fini(message_memory);
}

static rosidl_typesupport_introspection_c__MessageMember musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_message_member_array[2] = {
  {
    "distance",  // name
    rosidl_typesupport_introspection_c__ROS_TYPE_FLOAT,  // type
    0,  // upper bound of string
    NULL,  // members of sub message
    false,  // is array
    0,  // array size
    false,  // is upper bound
    offsetof(musashi_msgs__msg__Polar2D, distance),  // bytes offset in struct
    NULL,  // default value
    NULL,  // size() function pointer
    NULL,  // get_const(index) function pointer
    NULL,  // get(index) function pointer
    NULL,  // fetch(index, &value) function pointer
    NULL,  // assign(index, value) function pointer
    NULL  // resize(index) function pointer
  },
  {
    "angle",  // name
    rosidl_typesupport_introspection_c__ROS_TYPE_FLOAT,  // type
    0,  // upper bound of string
    NULL,  // members of sub message
    false,  // is array
    0,  // array size
    false,  // is upper bound
    offsetof(musashi_msgs__msg__Polar2D, angle),  // bytes offset in struct
    NULL,  // default value
    NULL,  // size() function pointer
    NULL,  // get_const(index) function pointer
    NULL,  // get(index) function pointer
    NULL,  // fetch(index, &value) function pointer
    NULL,  // assign(index, value) function pointer
    NULL  // resize(index) function pointer
  }
};

static const rosidl_typesupport_introspection_c__MessageMembers musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_message_members = {
  "musashi_msgs__msg",  // message namespace
  "Polar2D",  // message name
  2,  // number of fields
  sizeof(musashi_msgs__msg__Polar2D),
  musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_message_member_array,  // message members
  musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_init_function,  // function to initialize message memory (memory has to be allocated)
  musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_fini_function  // function to terminate message instance (will not free memory)
};

// this is not const since it must be initialized on first access
// since C does not allow non-integral compile-time constants
static rosidl_message_type_support_t musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_message_type_support_handle = {
  0,
  &musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_message_members,
  get_message_typesupport_handle_function,
};

ROSIDL_TYPESUPPORT_INTROSPECTION_C_EXPORT_musashi_msgs
const rosidl_message_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_introspection_c, musashi_msgs, msg, Polar2D)() {
  if (!musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_message_type_support_handle.typesupport_identifier) {
    musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_message_type_support_handle.typesupport_identifier =
      rosidl_typesupport_introspection_c__identifier;
  }
  return &musashi_msgs__msg__Polar2D__rosidl_typesupport_introspection_c__Polar2D_message_type_support_handle;
}
#ifdef __cplusplus
}
#endif
