// generated from rosidl_generator_c/resource/idl__functions.h.em
// with input from musashi_msgs:msg/PlayerStates.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__FUNCTIONS_H_
#define MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__FUNCTIONS_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include <stdbool.h>
#include <stdlib.h>

#include "rosidl_runtime_c/visibility_control.h"
#include "musashi_msgs/msg/rosidl_generator_c__visibility_control.h"

#include "musashi_msgs/msg/detail/player_states__struct.h"

/// Initialize msg/PlayerStates message.
/**
 * If the init function is called twice for the same message without
 * calling fini inbetween previously allocated memory will be leaked.
 * \param[in,out] msg The previously allocated message pointer.
 * Fields without a default value will not be initialized by this function.
 * You might want to call memset(msg, 0, sizeof(
 * musashi_msgs__msg__PlayerStates
 * )) before or use
 * musashi_msgs__msg__PlayerStates__create()
 * to allocate and initialize the message.
 * \return true if initialization was successful, otherwise false
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
bool
musashi_msgs__msg__PlayerStates__init(musashi_msgs__msg__PlayerStates * msg);

/// Finalize msg/PlayerStates message.
/**
 * \param[in,out] msg The allocated message pointer.
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
void
musashi_msgs__msg__PlayerStates__fini(musashi_msgs__msg__PlayerStates * msg);

/// Create msg/PlayerStates message.
/**
 * It allocates the memory for the message, sets the memory to zero, and
 * calls
 * musashi_msgs__msg__PlayerStates__init().
 * \return The pointer to the initialized message if successful,
 * otherwise NULL
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
musashi_msgs__msg__PlayerStates *
musashi_msgs__msg__PlayerStates__create();

/// Destroy msg/PlayerStates message.
/**
 * It calls
 * musashi_msgs__msg__PlayerStates__fini()
 * and frees the memory of the message.
 * \param[in,out] msg The allocated message pointer.
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
void
musashi_msgs__msg__PlayerStates__destroy(musashi_msgs__msg__PlayerStates * msg);

/// Check for msg/PlayerStates message equality.
/**
 * \param[in] lhs The message on the left hand size of the equality operator.
 * \param[in] rhs The message on the right hand size of the equality operator.
 * \return true if messages are equal, otherwise false.
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
bool
musashi_msgs__msg__PlayerStates__are_equal(const musashi_msgs__msg__PlayerStates * lhs, const musashi_msgs__msg__PlayerStates * rhs);

/// Copy a msg/PlayerStates message.
/**
 * This functions performs a deep copy, as opposed to the shallow copy that
 * plain assignment yields.
 *
 * \param[in] input The source message pointer.
 * \param[out] output The target message pointer, which must
 *   have been initialized before calling this function.
 * \return true if successful, or false if either pointer is null
 *   or memory allocation fails.
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
bool
musashi_msgs__msg__PlayerStates__copy(
  const musashi_msgs__msg__PlayerStates * input,
  musashi_msgs__msg__PlayerStates * output);

/// Initialize array of msg/PlayerStates messages.
/**
 * It allocates the memory for the number of elements and calls
 * musashi_msgs__msg__PlayerStates__init()
 * for each element of the array.
 * \param[in,out] array The allocated array pointer.
 * \param[in] size The size / capacity of the array.
 * \return true if initialization was successful, otherwise false
 * If the array pointer is valid and the size is zero it is guaranteed
 # to return true.
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
bool
musashi_msgs__msg__PlayerStates__Sequence__init(musashi_msgs__msg__PlayerStates__Sequence * array, size_t size);

/// Finalize array of msg/PlayerStates messages.
/**
 * It calls
 * musashi_msgs__msg__PlayerStates__fini()
 * for each element of the array and frees the memory for the number of
 * elements.
 * \param[in,out] array The initialized array pointer.
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
void
musashi_msgs__msg__PlayerStates__Sequence__fini(musashi_msgs__msg__PlayerStates__Sequence * array);

/// Create array of msg/PlayerStates messages.
/**
 * It allocates the memory for the array and calls
 * musashi_msgs__msg__PlayerStates__Sequence__init().
 * \param[in] size The size / capacity of the array.
 * \return The pointer to the initialized array if successful, otherwise NULL
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
musashi_msgs__msg__PlayerStates__Sequence *
musashi_msgs__msg__PlayerStates__Sequence__create(size_t size);

/// Destroy array of msg/PlayerStates messages.
/**
 * It calls
 * musashi_msgs__msg__PlayerStates__Sequence__fini()
 * on the array,
 * and frees the memory of the array.
 * \param[in,out] array The initialized array pointer.
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
void
musashi_msgs__msg__PlayerStates__Sequence__destroy(musashi_msgs__msg__PlayerStates__Sequence * array);

/// Check for msg/PlayerStates message array equality.
/**
 * \param[in] lhs The message array on the left hand size of the equality operator.
 * \param[in] rhs The message array on the right hand size of the equality operator.
 * \return true if message arrays are equal in size and content, otherwise false.
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
bool
musashi_msgs__msg__PlayerStates__Sequence__are_equal(const musashi_msgs__msg__PlayerStates__Sequence * lhs, const musashi_msgs__msg__PlayerStates__Sequence * rhs);

/// Copy an array of msg/PlayerStates messages.
/**
 * This functions performs a deep copy, as opposed to the shallow copy that
 * plain assignment yields.
 *
 * \param[in] input The source array pointer.
 * \param[out] output The target array pointer, which must
 *   have been initialized before calling this function.
 * \return true if successful, or false if either pointer
 *   is null or memory allocation fails.
 */
ROSIDL_GENERATOR_C_PUBLIC_musashi_msgs
bool
musashi_msgs__msg__PlayerStates__Sequence__copy(
  const musashi_msgs__msg__PlayerStates__Sequence * input,
  musashi_msgs__msg__PlayerStates__Sequence * output);

#ifdef __cplusplus
}
#endif

#endif  // MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__FUNCTIONS_H_
