// generated from rosidl_generator_c/resource/idl__struct.h.em
// with input from musashi_msgs:msg/PlayerStates.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__STRUCT_H_
#define MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__STRUCT_H_

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
// Member 'players'
#include "musashi_msgs/msg/detail/player_state__struct.h"

/// Struct defined in msg/PlayerStates in the package musashi_msgs.
typedef struct musashi_msgs__msg__PlayerStates
{
  std_msgs__msg__Header header;
  musashi_msgs__msg__PlayerState players[5];
} musashi_msgs__msg__PlayerStates;

// Struct for a sequence of musashi_msgs__msg__PlayerStates.
typedef struct musashi_msgs__msg__PlayerStates__Sequence
{
  musashi_msgs__msg__PlayerStates * data;
  /// The number of valid items in data
  size_t size;
  /// The number of allocated items in data
  size_t capacity;
} musashi_msgs__msg__PlayerStates__Sequence;

#ifdef __cplusplus
}
#endif

#endif  // MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__STRUCT_H_
