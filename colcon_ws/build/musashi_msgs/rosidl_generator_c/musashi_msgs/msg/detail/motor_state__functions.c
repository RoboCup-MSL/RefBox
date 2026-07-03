// generated from rosidl_generator_c/resource/idl__functions.c.em
// with input from musashi_msgs:msg/MotorState.idl
// generated code does not contain a copyright notice
#include "musashi_msgs/msg/detail/motor_state__functions.h"

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#include "rcutils/allocator.h"


// Include directives for member types
// Member `header`
#include "std_msgs/msg/detail/header__functions.h"
// Member `motor_name`
#include "rosidl_runtime_c/string_functions.h"

bool
musashi_msgs__msg__MotorState__init(musashi_msgs__msg__MotorState * msg)
{
  if (!msg) {
    return false;
  }
  // header
  if (!std_msgs__msg__Header__init(&msg->header)) {
    musashi_msgs__msg__MotorState__fini(msg);
    return false;
  }
  // motor_name
  if (!rosidl_runtime_c__String__init(&msg->motor_name)) {
    musashi_msgs__msg__MotorState__fini(msg);
    return false;
  }
  // position
  // velocity
  // current
  return true;
}

void
musashi_msgs__msg__MotorState__fini(musashi_msgs__msg__MotorState * msg)
{
  if (!msg) {
    return;
  }
  // header
  std_msgs__msg__Header__fini(&msg->header);
  // motor_name
  rosidl_runtime_c__String__fini(&msg->motor_name);
  // position
  // velocity
  // current
}

bool
musashi_msgs__msg__MotorState__are_equal(const musashi_msgs__msg__MotorState * lhs, const musashi_msgs__msg__MotorState * rhs)
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
  // motor_name
  if (!rosidl_runtime_c__String__are_equal(
      &(lhs->motor_name), &(rhs->motor_name)))
  {
    return false;
  }
  // position
  if (lhs->position != rhs->position) {
    return false;
  }
  // velocity
  if (lhs->velocity != rhs->velocity) {
    return false;
  }
  // current
  if (lhs->current != rhs->current) {
    return false;
  }
  return true;
}

bool
musashi_msgs__msg__MotorState__copy(
  const musashi_msgs__msg__MotorState * input,
  musashi_msgs__msg__MotorState * output)
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
  // motor_name
  if (!rosidl_runtime_c__String__copy(
      &(input->motor_name), &(output->motor_name)))
  {
    return false;
  }
  // position
  output->position = input->position;
  // velocity
  output->velocity = input->velocity;
  // current
  output->current = input->current;
  return true;
}

musashi_msgs__msg__MotorState *
musashi_msgs__msg__MotorState__create()
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  musashi_msgs__msg__MotorState * msg = (musashi_msgs__msg__MotorState *)allocator.allocate(sizeof(musashi_msgs__msg__MotorState), allocator.state);
  if (!msg) {
    return NULL;
  }
  memset(msg, 0, sizeof(musashi_msgs__msg__MotorState));
  bool success = musashi_msgs__msg__MotorState__init(msg);
  if (!success) {
    allocator.deallocate(msg, allocator.state);
    return NULL;
  }
  return msg;
}

void
musashi_msgs__msg__MotorState__destroy(musashi_msgs__msg__MotorState * msg)
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  if (msg) {
    musashi_msgs__msg__MotorState__fini(msg);
  }
  allocator.deallocate(msg, allocator.state);
}


bool
musashi_msgs__msg__MotorState__Sequence__init(musashi_msgs__msg__MotorState__Sequence * array, size_t size)
{
  if (!array) {
    return false;
  }
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  musashi_msgs__msg__MotorState * data = NULL;

  if (size) {
    data = (musashi_msgs__msg__MotorState *)allocator.zero_allocate(size, sizeof(musashi_msgs__msg__MotorState), allocator.state);
    if (!data) {
      return false;
    }
    // initialize all array elements
    size_t i;
    for (i = 0; i < size; ++i) {
      bool success = musashi_msgs__msg__MotorState__init(&data[i]);
      if (!success) {
        break;
      }
    }
    if (i < size) {
      // if initialization failed finalize the already initialized array elements
      for (; i > 0; --i) {
        musashi_msgs__msg__MotorState__fini(&data[i - 1]);
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
musashi_msgs__msg__MotorState__Sequence__fini(musashi_msgs__msg__MotorState__Sequence * array)
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
      musashi_msgs__msg__MotorState__fini(&array->data[i]);
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

musashi_msgs__msg__MotorState__Sequence *
musashi_msgs__msg__MotorState__Sequence__create(size_t size)
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  musashi_msgs__msg__MotorState__Sequence * array = (musashi_msgs__msg__MotorState__Sequence *)allocator.allocate(sizeof(musashi_msgs__msg__MotorState__Sequence), allocator.state);
  if (!array) {
    return NULL;
  }
  bool success = musashi_msgs__msg__MotorState__Sequence__init(array, size);
  if (!success) {
    allocator.deallocate(array, allocator.state);
    return NULL;
  }
  return array;
}

void
musashi_msgs__msg__MotorState__Sequence__destroy(musashi_msgs__msg__MotorState__Sequence * array)
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  if (array) {
    musashi_msgs__msg__MotorState__Sequence__fini(array);
  }
  allocator.deallocate(array, allocator.state);
}

bool
musashi_msgs__msg__MotorState__Sequence__are_equal(const musashi_msgs__msg__MotorState__Sequence * lhs, const musashi_msgs__msg__MotorState__Sequence * rhs)
{
  if (!lhs || !rhs) {
    return false;
  }
  if (lhs->size != rhs->size) {
    return false;
  }
  for (size_t i = 0; i < lhs->size; ++i) {
    if (!musashi_msgs__msg__MotorState__are_equal(&(lhs->data[i]), &(rhs->data[i]))) {
      return false;
    }
  }
  return true;
}

bool
musashi_msgs__msg__MotorState__Sequence__copy(
  const musashi_msgs__msg__MotorState__Sequence * input,
  musashi_msgs__msg__MotorState__Sequence * output)
{
  if (!input || !output) {
    return false;
  }
  if (output->capacity < input->size) {
    const size_t allocation_size =
      input->size * sizeof(musashi_msgs__msg__MotorState);
    rcutils_allocator_t allocator = rcutils_get_default_allocator();
    musashi_msgs__msg__MotorState * data =
      (musashi_msgs__msg__MotorState *)allocator.reallocate(
      output->data, allocation_size, allocator.state);
    if (!data) {
      return false;
    }
    // If reallocation succeeded, memory may or may not have been moved
    // to fulfill the allocation request, invalidating output->data.
    output->data = data;
    for (size_t i = output->capacity; i < input->size; ++i) {
      if (!musashi_msgs__msg__MotorState__init(&output->data[i])) {
        // If initialization of any new item fails, roll back
        // all previously initialized items. Existing items
        // in output are to be left unmodified.
        for (; i-- > output->capacity; ) {
          musashi_msgs__msg__MotorState__fini(&output->data[i]);
        }
        return false;
      }
    }
    output->capacity = input->size;
  }
  output->size = input->size;
  for (size_t i = 0; i < input->size; ++i) {
    if (!musashi_msgs__msg__MotorState__copy(
        &(input->data[i]), &(output->data[i])))
    {
      return false;
    }
  }
  return true;
}
