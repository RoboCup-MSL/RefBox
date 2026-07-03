// generated from rosidl_generator_cpp/resource/idl__traits.hpp.em
// with input from musashi_msgs:msg/MotorStates.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__TRAITS_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__TRAITS_HPP_

#include <stdint.h>

#include <sstream>
#include <string>
#include <type_traits>

#include "musashi_msgs/msg/detail/motor_states__struct.hpp"
#include "rosidl_runtime_cpp/traits.hpp"

// Include directives for member types
// Member 'header'
#include "std_msgs/msg/detail/header__traits.hpp"
// Member 'states'
#include "musashi_msgs/msg/detail/motor_state__traits.hpp"

namespace musashi_msgs
{

namespace msg
{

inline void to_flow_style_yaml(
  const MotorStates & msg,
  std::ostream & out)
{
  out << "{";
  // member: header
  {
    out << "header: ";
    to_flow_style_yaml(msg.header, out);
    out << ", ";
  }

  // member: states
  {
    if (msg.states.size() == 0) {
      out << "states: []";
    } else {
      out << "states: [";
      size_t pending_items = msg.states.size();
      for (auto item : msg.states) {
        to_flow_style_yaml(item, out);
        if (--pending_items > 0) {
          out << ", ";
        }
      }
      out << "]";
    }
  }
  out << "}";
}  // NOLINT(readability/fn_size)

inline void to_block_style_yaml(
  const MotorStates & msg,
  std::ostream & out, size_t indentation = 0)
{
  // member: header
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "header:\n";
    to_block_style_yaml(msg.header, out, indentation + 2);
  }

  // member: states
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    if (msg.states.size() == 0) {
      out << "states: []\n";
    } else {
      out << "states:\n";
      for (auto item : msg.states) {
        if (indentation > 0) {
          out << std::string(indentation, ' ');
        }
        out << "-\n";
        to_block_style_yaml(item, out, indentation + 2);
      }
    }
  }
}  // NOLINT(readability/fn_size)

inline std::string to_yaml(const MotorStates & msg, bool use_flow_style = false)
{
  std::ostringstream out;
  if (use_flow_style) {
    to_flow_style_yaml(msg, out);
  } else {
    to_block_style_yaml(msg, out);
  }
  return out.str();
}

}  // namespace msg

}  // namespace musashi_msgs

namespace rosidl_generator_traits
{

[[deprecated("use musashi_msgs::msg::to_block_style_yaml() instead")]]
inline void to_yaml(
  const musashi_msgs::msg::MotorStates & msg,
  std::ostream & out, size_t indentation = 0)
{
  musashi_msgs::msg::to_block_style_yaml(msg, out, indentation);
}

[[deprecated("use musashi_msgs::msg::to_yaml() instead")]]
inline std::string to_yaml(const musashi_msgs::msg::MotorStates & msg)
{
  return musashi_msgs::msg::to_yaml(msg);
}

template<>
inline const char * data_type<musashi_msgs::msg::MotorStates>()
{
  return "musashi_msgs::msg::MotorStates";
}

template<>
inline const char * name<musashi_msgs::msg::MotorStates>()
{
  return "musashi_msgs/msg/MotorStates";
}

template<>
struct has_fixed_size<musashi_msgs::msg::MotorStates>
  : std::integral_constant<bool, false> {};

template<>
struct has_bounded_size<musashi_msgs::msg::MotorStates>
  : std::integral_constant<bool, false> {};

template<>
struct is_message<musashi_msgs::msg::MotorStates>
  : std::true_type {};

}  // namespace rosidl_generator_traits

#endif  // MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__TRAITS_HPP_
