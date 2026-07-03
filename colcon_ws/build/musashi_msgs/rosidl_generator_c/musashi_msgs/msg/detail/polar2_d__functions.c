// generated from rosidl_generator_c/resource/idl__functions.c.em
// with input from musashi_msgs:msg/Polar2D.idl
// generated code does not contain a copyright notice
#include "musashi_msgs/msg/detail/polar2_d__functions.h"

#include <assert.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

#include "rcutils/allocator.h"


bool
musashi_msgs__msg__Polar2D__init(musashi_msgs__msg__Polar2D * msg)
{
  if (!msg) {
    return false;
  }
  // distance
  // angle
  return true;
}

void
musashi_msgs__msg__Polar2D__fini(musashi_msgs__msg__Polar2D * msg)
{
  if (!msg) {
    return;
  }
  // distance
  // angle
}

bool
musashi_msgs__msg__Polar2D__are_equal(const musashi_msgs__msg__Polar2D * lhs, const musashi_msgs__msg__Polar2D * rhs)
{
  if (!lhs || !rhs) {
    return false;
  }
  // distance
  if (lhs->distance != rhs->distance) {
    return false;
  }
  // angle
  if (lhs->angle != rhs->angle) {
    return false;
  }
  return true;
}

bool
musashi_msgs__msg__Polar2D__copy(
  const musashi_msgs__msg__Polar2D * input,
  musashi_msgs__msg__Polar2D * output)
{
  if (!input || !output) {
    return false;
  }
  // distance
  output->distance = input->distance;
  // angle
  output->angle = input->angle;
  return true;
}

musashi_msgs__msg__Polar2D *
musashi_msgs__msg__Polar2D__create()
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  musashi_msgs__msg__Polar2D * msg = (musashi_msgs__msg__Polar2D *)allocator.allocate(sizeof(musashi_msgs__msg__Polar2D), allocator.state);
  if (!msg) {
    return NULL;
  }
  memset(msg, 0, sizeof(musashi_msgs__msg__Polar2D));
  bool success = musashi_msgs__msg__Polar2D__init(msg);
  if (!success) {
    allocator.deallocate(msg, allocator.state);
    return NULL;
  }
  return msg;
}

void
musashi_msgs__msg__Polar2D__destroy(musashi_msgs__msg__Polar2D * msg)
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  if (msg) {
    musashi_msgs__msg__Polar2D__fini(msg);
  }
  allocator.deallocate(msg, allocator.state);
}


bool
musashi_msgs__msg__Polar2D__Sequence__init(musashi_msgs__msg__Polar2D__Sequence * array, size_t size)
{
  if (!array) {
    return false;
  }
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  musashi_msgs__msg__Polar2D * data = NULL;

  if (size) {
    data = (musashi_msgs__msg__Polar2D *)allocator.zero_allocate(size, sizeof(musashi_msgs__msg__Polar2D), allocator.state);
    if (!data) {
      return false;
    }
    // initialize all array elements
    size_t i;
    for (i = 0; i < size; ++i) {
      bool success = musashi_msgs__msg__Polar2D__init(&data[i]);
      if (!success) {
        break;
      }
    }
    if (i < size) {
      // if initialization failed finalize the already initialized array elements
      for (; i > 0; --i) {
        musashi_msgs__msg__Polar2D__fini(&data[i - 1]);
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
musashi_msgs__msg__Polar2D__Sequence__fini(musashi_msgs__msg__Polar2D__Sequence * array)
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
      musashi_msgs__msg__Polar2D__fini(&array->data[i]);
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

musashi_msgs__msg__Polar2D__Sequence *
musashi_msgs__msg__Polar2D__Sequence__create(size_t size)
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  musashi_msgs__msg__Polar2D__Sequence * array = (musashi_msgs__msg__Polar2D__Sequence *)allocator.allocate(sizeof(musashi_msgs__msg__Polar2D__Sequence), allocator.state);
  if (!array) {
    return NULL;
  }
  bool success = musashi_msgs__msg__Polar2D__Sequence__init(array, size);
  if (!success) {
    allocator.deallocate(array, allocator.state);
    return NULL;
  }
  return array;
}

void
musashi_msgs__msg__Polar2D__Sequence__destroy(musashi_msgs__msg__Polar2D__Sequence * array)
{
  rcutils_allocator_t allocator = rcutils_get_default_allocator();
  if (array) {
    musashi_msgs__msg__Polar2D__Sequence__fini(array);
  }
  allocator.deallocate(array, allocator.state);
}

bool
musashi_msgs__msg__Polar2D__Sequence__are_equal(const musashi_msgs__msg__Polar2D__Sequence * lhs, const musashi_msgs__msg__Polar2D__Sequence * rhs)
{
  if (!lhs || !rhs) {
    return false;
  }
  if (lhs->size != rhs->size) {
    return false;
  }
  for (size_t i = 0; i < lhs->size; ++i) {
    if (!musashi_msgs__msg__Polar2D__are_equal(&(lhs->data[i]), &(rhs->data[i]))) {
      return false;
    }
  }
  return true;
}

bool
musashi_msgs__msg__Polar2D__Sequence__copy(
  const musashi_msgs__msg__Polar2D__Sequence * input,
  musashi_msgs__msg__Polar2D__Sequence * output)
{
  if (!input || !output) {
    return false;
  }
  if (output->capacity < input->size) {
    const size_t allocation_size =
      input->size * sizeof(musashi_msgs__msg__Polar2D);
    rcutils_allocator_t allocator = rcutils_get_default_allocator();
    musashi_msgs__msg__Polar2D * data =
      (musashi_msgs__msg__Polar2D *)allocator.reallocate(
      output->data, allocation_size, allocator.state);
    if (!data) {
      return false;
    }
    // If reallocation succeeded, memory may or may not have been moved
    // to fulfill the allocation request, invalidating output->data.
    output->data = data;
    for (size_t i = output->capacity; i < input->size; ++i) {
      if (!musashi_msgs__msg__Polar2D__init(&output->data[i])) {
        // If initialization of any new item fails, roll back
        // all previously initialized items. Existing items
        // in output are to be left unmodified.
        for (; i-- > output->capacity; ) {
          musashi_msgs__msg__Polar2D__fini(&output->data[i]);
        }
        return false;
      }
    }
    output->capacity = input->size;
  }
  output->size = input->size;
  for (size_t i = 0; i < input->size; ++i) {
    if (!musashi_msgs__msg__Polar2D__copy(
        &(input->data[i]), &(output->data[i])))
    {
      return false;
    }
  }
  return true;
}
