// generated from rosidl_typesupport_introspection_cpp/resource/idl__type_support.cpp.em
// with input from musashi_msgs:msg/Polar2D.idl
// generated code does not contain a copyright notice

#include "array"
#include "cstddef"
#include "string"
#include "vector"
#include "rosidl_runtime_c/message_type_support_struct.h"
#include "rosidl_typesupport_cpp/message_type_support.hpp"
#include "rosidl_typesupport_interface/macros.h"
#include "musashi_msgs/msg/detail/polar2_d__struct.hpp"
#include "rosidl_typesupport_introspection_cpp/field_types.hpp"
#include "rosidl_typesupport_introspection_cpp/identifier.hpp"
#include "rosidl_typesupport_introspection_cpp/message_introspection.hpp"
#include "rosidl_typesupport_introspection_cpp/message_type_support_decl.hpp"
#include "rosidl_typesupport_introspection_cpp/visibility_control.h"

namespace musashi_msgs
{

namespace msg
{

namespace rosidl_typesupport_introspection_cpp
{

void Polar2D_init_function(
  void * message_memory, rosidl_runtime_cpp::MessageInitialization _init)
{
  new (message_memory) musashi_msgs::msg::Polar2D(_init);
}

void Polar2D_fini_function(void * message_memory)
{
  auto typed_message = static_cast<musashi_msgs::msg::Polar2D *>(message_memory);
  typed_message->~Polar2D();
}

static const ::rosidl_typesupport_introspection_cpp::MessageMember Polar2D_message_member_array[2] = {
  {
    "distance",  // name
    ::rosidl_typesupport_introspection_cpp::ROS_TYPE_FLOAT,  // type
    0,  // upper bound of string
    nullptr,  // members of sub message
    false,  // is array
    0,  // array size
    false,  // is upper bound
    offsetof(musashi_msgs::msg::Polar2D, distance),  // bytes offset in struct
    nullptr,  // default value
    nullptr,  // size() function pointer
    nullptr,  // get_const(index) function pointer
    nullptr,  // get(index) function pointer
    nullptr,  // fetch(index, &value) function pointer
    nullptr,  // assign(index, value) function pointer
    nullptr  // resize(index) function pointer
  },
  {
    "angle",  // name
    ::rosidl_typesupport_introspection_cpp::ROS_TYPE_FLOAT,  // type
    0,  // upper bound of string
    nullptr,  // members of sub message
    false,  // is array
    0,  // array size
    false,  // is upper bound
    offsetof(musashi_msgs::msg::Polar2D, angle),  // bytes offset in struct
    nullptr,  // default value
    nullptr,  // size() function pointer
    nullptr,  // get_const(index) function pointer
    nullptr,  // get(index) function pointer
    nullptr,  // fetch(index, &value) function pointer
    nullptr,  // assign(index, value) function pointer
    nullptr  // resize(index) function pointer
  }
};

static const ::rosidl_typesupport_introspection_cpp::MessageMembers Polar2D_message_members = {
  "musashi_msgs::msg",  // message namespace
  "Polar2D",  // message name
  2,  // number of fields
  sizeof(musashi_msgs::msg::Polar2D),
  Polar2D_message_member_array,  // message members
  Polar2D_init_function,  // function to initialize message memory (memory has to be allocated)
  Polar2D_fini_function  // function to terminate message instance (will not free memory)
};

static const rosidl_message_type_support_t Polar2D_message_type_support_handle = {
  ::rosidl_typesupport_introspection_cpp::typesupport_identifier,
  &Polar2D_message_members,
  get_message_typesupport_handle_function,
};

}  // namespace rosidl_typesupport_introspection_cpp

}  // namespace msg

}  // namespace musashi_msgs


namespace rosidl_typesupport_introspection_cpp
{

template<>
ROSIDL_TYPESUPPORT_INTROSPECTION_CPP_PUBLIC
const rosidl_message_type_support_t *
get_message_type_support_handle<musashi_msgs::msg::Polar2D>()
{
  return &::musashi_msgs::msg::rosidl_typesupport_introspection_cpp::Polar2D_message_type_support_handle;
}

}  // namespace rosidl_typesupport_introspection_cpp

#ifdef __cplusplus
extern "C"
{
#endif

ROSIDL_TYPESUPPORT_INTROSPECTION_CPP_PUBLIC
const rosidl_message_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_introspection_cpp, musashi_msgs, msg, Polar2D)() {
  return &::musashi_msgs::msg::rosidl_typesupport_introspection_cpp::Polar2D_message_type_support_handle;
}

#ifdef __cplusplus
}
#endif
