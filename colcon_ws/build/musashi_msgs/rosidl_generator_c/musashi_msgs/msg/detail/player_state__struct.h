// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from musashi_msgs:msg/PlayerState.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATE__STRUCT_H_
#define MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATE__STRUCT_H_

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
// Member 'ball'
// Member 'goal'
// Member 'my_goal'
// Member 'obstacle'
#include "musashi_msgs/msg/detail/polar2_d__struct.h"
// Member 'position'
// Member 'moveto'
#include "geometry_msgs/msg/detail/pose__struct.h"

/// Struct defined in msg/PlayerState in the package musashi_msgs.
typedef struct musashi_msgs__msg__PlayerState
{
  std_msgs__msg__Header header;
  int32_t color;
  int32_t id;
  int32_t action;
  int32_t state;
  int32_t role;
  int32_t haveball;
  musashi_msgs__msg__Polar2D ball;
  musashi_msgs__msg__Polar2D goal;
  musashi_msgs__msg__Polar2D my_goal;
  geometry_msgs__msg__Pose position;
  geometry_msgs__msg__Pose moveto;
  musashi_msgs__msg__Polar2D obstacle;
} musashi_msgs__msg__PlayerState;

// Struct for a sequence of musashi_msgs__msg__PlayerState.
typedef struct musashi_msgs__msg__PlayerState__Sequence
{
  musashi_msgs__msg__PlayerState * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} musashi_msgs__msg__PlayerState__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATE__STRUCT_H_
