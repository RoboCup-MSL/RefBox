// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from musashi_msgs:msg/RefereeCmd.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__STRUCT_H_
#define MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__STRUCT_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


// Constants defined in the message

// Include directives for member types
// Member 'header'
#include "std_msgs/msg/detail/header__struct.h"
// Member 'command'
// Member 'target_team'
#include "rosidl_runtime_c/string.h"

/// Struct defined in msg/RefereeCmd in the package musashi_msgs.
typedef struct musashi_msgs__msg__RefereeCmd
{
  std_msgs__msg__Header header;
  rosidl_runtime_c__String command;
  rosidl_runtime_c__String target_team;
} musashi_msgs__msg__RefereeCmd;

// Struct for a sequence of musashi_msgs__msg__RefereeCmd.
typedef struct musashi_msgs__msg__RefereeCmd__Sequence
{
  musashi_msgs__msg__RefereeCmd * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} musashi_msgs__msg__RefereeCmd__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__STRUCT_H_
