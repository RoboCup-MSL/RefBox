// generated from rosidl_generator_c/resource/idl__functions.c.em
// with input from musashi_msgs:msg/PlayerState.idl
// generated code does not contain a copyright notice
#include "musashi_msgs/msg/detail/player_state__functions.h"

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#include "rcutils/allocator.h"


// Include directives for member types
// Member `header`
#include "std_msgs/msg/detail/header__functions.h"
// Member `ball`
// Member `goal`
// Member `my_goal`
// Member `obstacle`
#include "musashi_msgs/msg/detail/polar2_d__functions.h"
// Member `position`
// Member `moveto`
#include "geometry_msgs/msg/detail/pose__functions.h"

bool
musashi_msgs__msg__PlayerState__init(musashi_msgs__msg__PlayerState * msg)
{
  if (!msg) {
    return false;
  }
  // header
  if (!std_msgs__msg__Header__init(&msg->header)) {
    musashi_msgs__msg__PlayerState__fini(msg);
    return false;
  }
  // color
  // id
  // action
  // state
  // role
  // haveball
  // ball
  if (!musashi_msgs__msg__Polar2D__init(&msg->ball)) {
    musashi_msgs__msg__PlayerState__fini(msg);
    return false;
  }
  // goal
  if (!musashi_msgs__msg__Polar2D__init(&msg->goal)) {
    musashi_msgs__msg__PlayerState__fini(msg);
    return false;
  }
  // my_goal
  if (!musashi_msgs__msg__Polar2D__init(&msg->my_goal)) {
    musashi_msgs__msg__PlayerState__fini(msg);
    return false;
  }
  // position
  if (!geometry_msgs__msg__Pose__init(&msg->position)) {
    musashi_msgs__msg__PlayerState__fini(msg);
    return false;
  }
  // moveto
  if (!geometry_msgs__msg__Pose__init(&msg->moveto)) {
    musashi_msgs__msg__PlayerState__fini(msg);
    return false;
  }
  // obstacle
  if (!musashi_msgs__msg__Polar2D__init(&msg->obstacle)) {
    musashi_msgs__msg__PlayerState__fini(msg);
    return false;
  }
  return true;
}

void
musashi_msgs__msg__PlayerState__fini(musashi_msgs__msg__PlayerState * msg)
{
  if (!msg) {
    return;
  }
  // header
  std_msgs__msg__Header__fini(&msg->header);
  // color
  // id
  // action
  // state
  // role
  // haveball
  // ball
  musashi_msgs__msg__Polar2D__fini(&msg->ball);
  // goal
  musashi_msgs__msg__Polar2D__fini(&msg->goal);
  // my_goal
  musashi_msgs__msg__Polar2D__fini(&msg->my_goal);
  // position
  geometry_msgs__msg__Pose__fini(&msg->position);
  // moveto
  geometry_msgs__msg__Pose__fini(&msg->moveto);
  // obstacle
  musashi_msgs__msg__Polar2D__fini(&msg->obstacle);
}

bool
musashi_msgs__msg__PlayerState__are_equal(const musashi_msgs__msg__PlayerState * lhs, const musashi_msgs__msg__PlayerState * rhs)
{
  if (!lhs || !rhs) {
    return false;
  }
  // header
  if (!std_msgs__msg__Header__are_equal(
      &(lhs->header), &(rhs->header)))
  {
    return false;
  }
  // color
  if (lhs->color != rhs->color) {
    return false;
  }
  // id
  if (lhs->id != rhs->id) {
    return false;
  }
  // action
  if (lhs->action != rhs->action) {
    return false;
  }
  // state
  if (lhs->state != rhs->state) {
    return false;
  }
  // role
  if (lhs->role != rhs->role) {
    return false;
  }
  // haveball
  if (lhs->haveball != rhs->haveball) {
    return false;
  }
  // ball
  if (!musashi_msgs__msg__Polar2D__are_equal(
      &(lhs->ball), &(rhs->ball)))
  {
    return false;
  }
  // goal
  if (!musashi_msgs__msg__Polar2D__are_equal(
      &(lhs->goal), &(rhs->goal)))
  {
    return false;
  }
  // my_goal
  if (!musashi_msgs__msg__Polar2D__are_equal(
      &(lhs->my_goal), &(rhs->my_goal)))
  {
    return false;
  }
  // position
  if (!geometry_msgs__msg__Pose__are_equal(
      &(lhs->position), &(rhs->position)))
  {
    return false;
  }
  // moveto
  if (!geometry_msgs__msg__Pose__are_equal(
      &(lhs->moveto), &(rhs->moveto)))
  {
    return false;
  }
  // obstacle
  if (!musashi_msgs__msg__Polar2D__are_equal(
      &(lhs->obstacle), &(rhs->obstacle)))
  {
    return false;
  }
  return true;
}

bool
musashi_msgs__msg__PlayerState__copy(
  const musashi_msgs__msg__PlayerState * input,
  musashi_msgs__msg__PlayerState * output)
{
  if (!input || !output) {
    return false;
  }
  // header
  if (!std_msgs__msg__Header__copy(
      &(input->header), &(output->header)))
  {
    return false;
  }
  // color
  output->color = input->color;
  // id
  output->id = input->id;
  // action
  output->action = input->action;
  // state
  output->state = input->state;
  // role
  output->role = input->role;
  // haveball
  output->haveball = input->haveball;
  // ball
  if (!musashi_msgs__msg__Polar2D__copy(
      &(input->ball), &(output->ball)))
  {
    return false;
  }
  // goal
  if (!musashi_msgs__msg__Polar2D__copy(
      &(input->goal), &(output->goal)))
  {
    return false;
  }
  // my_goal
  if (!musashi_msgs__msg__Polar2D__copy(
      &(input->my_goal), &(output->my_goal)))
  {
    return false;
  }
  // position
  if (!geometry_msgs__msg__Pose__copy(
      &(input->position), &(output->position)))
  {
    return false;
  }
  // moveto
  if (!geometry_msgs__msg__Pose__copy(
      &(input->moveto), &(output->moveto)))
  {
    return false;
  }
  // obstacle
  if (!musashi_msgs__msg__Polar2D__copy(
      &(input->obstacle), &(output->obstacle)))
  {
    return false;
  }
  return true;
}

musashi_msgs__msg__PlayerState *
musashi_msgs__msg__PlayerState__create()
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  musashi_msgs__msg__PlayerState * msg = (musashi_msgs__msg__PlayerState *)allocator.allocate(sizeof(musashi_msgs__msg__PlayerState), allocator.state);
  if (!msg) {
    return NULL;
  }
  memset(msg, 0, sizeof(musashi_msgs__msg__PlayerState));
  bool success = musashi_msgs__msg__PlayerState__init(msg);
  if (!success) {
    allocator.deallocate(msg, allocator.state);
    return NULL;
  }
  return msg;
}

void
musashi_msgs__msg__PlayerState__destroy(musashi_msgs__msg__PlayerState * msg)
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  if (msg) {
    musashi_msgs__msg__PlayerState__fini(msg);
  }
  allocator.deallocate(msg, allocator.state);
}


bool
musashi_msgs__msg__PlayerState__Sequence__init(musashi_msgs__msg__PlayerState__Sequence * array, size_t size)
{
  if (!array) {
    return false;
  }
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  musashi_msgs__msg__PlayerState * data = NULL;

  if (size) {
    data = (musashi_msgs__msg__PlayerState *)allocator.zero_allocate(size, sizeof(musashi_msgs__msg__PlayerState), allocator.state);
    if (!data) {
      return false;
    }
    // initialize all array elements
    size_t i;
    for (i = 0; i < size; ++i) {
      bool success = musashi_msgs__msg__PlayerState__init(&data[i]);
      if (!success) {
        break;
      }
    }
    if (i < size) {
      // if initialization failed finalize the already initialized array elements
      for (; i > 0; --i) {
        musashi_msgs__msg__PlayerState__fini(&data[i - 1]);
      }
      allocator.deallocate(data, allocator.state);
      return false;
    }
  }
  array->data = data;
  array->size = size;
  array->capacity = size;
  return true;
}

void
musashi_msgs__msg__PlayerState__Sequence__fini(musashi_msgs__msg__PlayerState__Sequence * array)
{
  if (!array) {
    return;
  }
  rcutils_allocator_t allocator = rcutils_get_default_allocator();

  if (array->data) {
    // ensure that data and capacity values are consistent
    assert(array->capacity > 0);
    // finalize all array elements
    for (size_t i = 0; i < array->capacity; ++i) {
      musashi_msgs__msg__PlayerState__fini(&array->data[i]);
    }
    allocator.deallocate(array->data, allocator.state);
    array->data = NULL;
    array->size = 0;
    array->capacity = 0;
  } else {
    // ensure that data, size, and capacity values are consistent
    assert(0 == array->size);
    assert(0 == array->capacity);
  }
}

musashi_msgs__msg__PlayerState__Sequence *
musashi_msgs__msg__PlayerState__Sequence__create(size_t size)
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  musashi_msgs__msg__PlayerState__Sequence * array = (musashi_msgs__msg__PlayerState__Sequence *)allocator.allocate(sizeof(musashi_msgs__msg__PlayerState__Sequence), allocator.state);
  if (!array) {
    return NULL;
  }
  bool success = musashi_msgs__msg__PlayerState__Sequence__init(array, size);
  if (!success) {
    allocator.deallocate(array, allocator.state);
    return NULL;
  }
  return array;
}

void
musashi_msgs__msg__PlayerState__Sequence__destroy(musashi_msgs__msg__PlayerState__Sequence * array)
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  if (array) {
    musashi_msgs__msg__PlayerState__Sequence__fini(array);
  }
  allocator.deallocate(array, allocator.state);
}

bool
musashi_msgs__msg__PlayerState__Sequence__are_equal(const musashi_msgs__msg__PlayerState__Sequence * lhs, const musashi_msgs__msg__PlayerState__Sequence * rhs)
{
  if (!lhs || !rhs) {
    return false;
  }
  if (lhs->size != rhs->size) {
    return false;
  }
  for (size_t i = 0; i < lhs->size; ++i) {
    if (!musashi_msgs__msg__PlayerState__are_equal(&(lhs->data[i]), &(rhs->data[i]))) {
      return false;
    }
  }
  return true;
}

bool
musashi_msgs__msg__PlayerState__Sequence__copy(
  const musashi_msgs__msg__PlayerState__Sequence * input,
  musashi_msgs__msg__PlayerState__Sequence * output)
{
  if (!input || !output) {
    return false;
  }
  if (output->capacity < input->size) {
    const size_t allocation_size =
      input->size * sizeof(musashi_msgs__msg__PlayerState);
    rcutils_allocator_t allocator = rcutils_get_default_allocator();
    musashi_msgs__msg__PlayerState * data =
      (musashi_msgs__msg__PlayerState *)allocator.reallocate(
      output->data, allocation_size, allocator.state);
    if (!data) {
      return false;
    }
    // If reallocation succeeded, memory may or may not have been moved
    // to fulfill the allocation request, invalidating output->data.
    output->data = data;
    for (size_t i = output->capacity; i < input->size; ++i) {
      if (!musashi_msgs__msg__PlayerState__init(&output->data[i])) {
        // If initialization of any new item fails, roll back
        // all previously initialized items. Existing items
        // in output are to be left unmodified.
        for (; i-- > output->capacity; ) {
          musashi_msgs__msg__PlayerState__fini(&output->data[i]);
        }
        return false;
      }
    }
    output->capacity = input->size;
  }
  output->size = input->size;
  for (size_t i = 0; i < input->size; ++i) {
    if (!musashi_msgs__msg__PlayerState__copy(
        &(input->data[i]), &(output->data[i])))
    {
      return false;
    }
  }
  return true;
}
