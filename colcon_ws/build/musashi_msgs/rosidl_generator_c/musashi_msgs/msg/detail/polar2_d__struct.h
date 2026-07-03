// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from musashi_msgs:msg/Polar2D.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__STRUCT_H_
#define MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__STRUCT_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>


// Constants defined in the message

/// Struct defined in msg/Polar2D in the package musashi_msgs.
typedef struct musashi_msgs__msg__Polar2D
{
  float distance;
  float angle;
} musashi_msgs__msg__Polar2D;

// Struct for a sequence of musashi_msgs__msg__Polar2D.
typedef struct musashi_msgs__msg__Polar2D__Sequence
{
  musashi_msgs__msg__Polar2D * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} musashi_msgs__msg__Polar2D__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__STRUCT_H_
