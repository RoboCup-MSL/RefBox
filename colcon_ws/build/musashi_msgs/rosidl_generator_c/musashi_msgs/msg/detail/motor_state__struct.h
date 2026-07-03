// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from musashi_msgs:msg/MotorState.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATE__STRUCT_H_
#define MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATE__STRUCT_H_

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
// Member 'motor_name'
#include "rosidl_runtime_c/string.h"

/// Struct defined in msg/MotorState in the package musashi_msgs.
typedef struct musashi_msgs__msg__MotorState
{
  std_msgs__msg__Header header;
  rosidl_runtime_c__String motor_name;
  double position;
  double velocity;
  double current;
} musashi_msgs__msg__MotorState;

// Struct for a sequence of musashi_msgs__msg__MotorState.
typedef struct musashi_msgs__msg__MotorState__Sequence
{
  musashi_msgs__msg__MotorState * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} musashi_msgs__msg__MotorState__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATE__STRUCT_H_
