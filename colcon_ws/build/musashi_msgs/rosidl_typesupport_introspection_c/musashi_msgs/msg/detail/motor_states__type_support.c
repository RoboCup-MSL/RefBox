// generated from rosidl_typesupport_introspection_c/resource/idl__type_support.c.em
// with input from musashi_msgs:msg/MotorStates.idl
// generated code does not contain a copyright notice

#include <stddef.h>
#include "musashi_msgs/msg/detail/motor_states__rosidl_typesupport_introspection_c.h"
#include "musashi_msgs/msg/rosidl_typesupport_introspection_c__visibility_control.h"
#include "rosidl_typesupport_introspection_c/field_types.h"
#include "rosidl_typesupport_introspection_c/identifier.h"
#include "rosidl_typesupport_introspection_c/message_introspection.h"
#include "musashi_msgs/msg/detail/motor_states__functions.h"
#include "musashi_msgs/msg/detail/motor_states__struct.h"


// Include directives for member types
// Member `header`
#include "std_msgs/msg/header.h"
// Member `header`
#include "std_msgs/msg/detail/header__rosidl_typesupport_introspection_c.h"
// Member `states`
#include "musashi_msgs/msg/motor_state.h"
// Member `states`
#include "musashi_msgs/msg/detail/motor_state__rosidl_typesupport_introspection_c.h"

#ifdef __cplusplus
extern "C"
{
#endif

void musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_init_function(
  void * message_memory, enum rosidl_runtime_c__message_initialization _init)
{
  // TODO(karsten1987): initializers are not yet implemented for typesupport c
  // see https://github.com/ros2/ros2/issues/397
  (void) _init;
  musashi_msgs__msg__MotorStates__init(message_memory);
}

void musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_fini_function(void * message_memory)
{
  musashi_msgs__msg__MotorStates__fini(message_memory);
}

size_t musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__size_function__MotorStates__states(
  const void * untyped_member)
{
  const musashi_msgs__msg__MotorState__Sequence * member =
    (const musashi_msgs__msg__MotorState__Sequence *)(untyped_member);
  return member->size;
}

const void * musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__get_const_function__MotorStates__states(
  const void * untyped_member, size_t index)
{
  const musashi_msgs__msg__MotorState__Sequence * member =
    (const musashi_msgs__msg__MotorState__Sequence *)(untyped_member);
  return &member->data[index];
}

void * musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__get_function__MotorStates__states(
  void * untyped_member, size_t index)
{
  musashi_msgs__msg__MotorState__Sequence * member =
    (musashi_msgs__msg__MotorState__Sequence *)(untyped_member);
  return &member->data[index];
}

void musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__fetch_function__MotorStates__states(
  const void * untyped_member, size_t index, void * untyped_value)
{
  const musashi_msgs__msg__MotorState * item =
    ((const musashi_msgs__msg__MotorState *)
    musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__get_const_function__MotorStates__states(untyped_member, index));
  musashi_msgs__msg__MotorState * value =
    (musashi_msgs__msg__MotorState *)(untyped_value);
  *value = *item;
}

void musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__assign_function__MotorStates__states(
  void * untyped_member, size_t index, const void * untyped_value)
{
  musashi_msgs__msg__MotorState * item =
    ((musashi_msgs__msg__MotorState *)
    musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__get_function__MotorStates__states(untyped_member, index));
  const musashi_msgs__msg__MotorState * value =
    (const musashi_msgs__msg__MotorState *)(untyped_value);
  *item = *value;
}

bool musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__resize_function__MotorStates__states(
  void * untyped_member, size_t size)
{
  musashi_msgs__msg__MotorState__Sequence * member =
    (musashi_msgs__msg__MotorState__Sequence *)(untyped_member);
  musashi_msgs__msg__MotorState__Sequence__fini(member);
  return musashi_msgs__msg__MotorState__Sequence__init(member, size);
}

static rosidl_typesupport_introspection_c__MessageMember musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_message_member_array[2] = {
  {
    "header",  // name
    rosidl_typesupport_introspection_c__ROS_TYPE_MESSAGE,  // type
    0,  // upper bound of string
    NULL,  // members of sub message (initialized later)
    false,  // is array
    0,  // array size
    false,  // is upper bound
    offsetof(musashi_msgs__msg__MotorStates, header),  // bytes offset in struct
    NULL,  // default value
    NULL,  // size() function pointer
    NULL,  // get_const(index) function pointer
    NULL,  // get(index) function pointer
    NULL,  // fetch(index, &value) function pointer
    NULL,  // assign(index, value) function pointer
    NULL  // resize(index) function pointer
  },
  {
    "states",  // name
    rosidl_typesupport_introspection_c__ROS_TYPE_MESSAGE,  // type
    0,  // upper bound of string
    NULL,  // members of sub message (initialized later)
    true,  // is array
    0,  // array size
    false,  // is upper bound
    offsetof(musashi_msgs__msg__MotorStates, states),  // bytes offset in struct
    NULL,  // default value
    musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__size_function__MotorStates__states,  // size() function pointer
    musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__get_const_function__MotorStates__states,  // get_const(index) function pointer
    musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__get_function__MotorStates__states,  // get(index) function pointer
    musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__fetch_function__MotorStates__states,  // fetch(index, &value) function pointer
    musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__assign_function__MotorStates__states,  // assign(index, value) function pointer
    musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__resize_function__MotorStates__states  // resize(index) function pointer
  }
};

static const rosidl_typesupport_introspection_c__MessageMembers musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_message_members = {
  "musashi_msgs__msg",  // message namespace
  "MotorStates",  // message name
  2,  // number of fields
  sizeof(musashi_msgs__msg__MotorStates),
  musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_message_member_array,  // message members
  musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_init_function,  // function to initialize message memory (memory has to be allocated)
  musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_fini_function  // function to terminate message instance (will not free memory)
};

// this is not const since it must be initialized on first access
// since C does not allow non-integral compile-time constants
static rosidl_message_type_support_t musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_message_type_support_handle = {
  0,
  &musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_message_members,
  get_message_typesupport_handle_function,
};

ROSIDL_TYPESUPPORT_INTROSPECTION_C_EXPORT_musashi_msgs
const rosidl_message_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_introspection_c, musashi_msgs, msg, MotorStates)() {
  musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_message_member_array[0].members_ =
    ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_introspection_c, std_msgs, msg, Header)();
  musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_message_member_array[1].members_ =
    ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_introspection_c, musashi_msgs, msg, MotorState)();
  if (!musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_message_type_support_handle.typesupport_identifier) {
    musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_message_type_support_handle.typesupport_identifier =
      rosidl_typesupport_introspection_c__identifier;
  }
  return &musashi_msgs__msg__MotorStates__rosidl_typesupport_introspection_c__MotorStates_message_type_support_handle;
}
#ifdef __cplusplus
}
#endif
