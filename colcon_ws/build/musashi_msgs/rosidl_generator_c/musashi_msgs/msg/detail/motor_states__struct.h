// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from musashi_msgs:msg/MotorStates.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__STRUCT_H_
#define MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__STRUCT_H_

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
// Member 'states'
#include "musashi_msgs/msg/detail/motor_state__struct.h"

/// Struct defined in msg/MotorStates in the package musashi_msgs.
typedef struct musashi_msgs__msg__MotorStates
{
  std_msgs__msg__Header header;
  musashi_msgs__msg__MotorState__Sequence states;
} musashi_msgs__msg__MotorStates;

// Struct for a sequence of musashi_msgs__msg__MotorStates.
typedef struct musashi_msgs__msg__MotorStates__Sequence
{
  musashi_msgs__msg__MotorStates * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} musashi_msgs__msg__MotorStates__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__STRUCT_H_
