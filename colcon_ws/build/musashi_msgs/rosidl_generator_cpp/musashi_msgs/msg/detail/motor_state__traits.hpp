// generated from rosidl_generator_cpp/resource/idl__traits.hpp.em
// with input from musashi_msgs:msg/MotorState.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATE__TRAITS_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATE__TRAITS_HPP_

#include <stdint.h>

#include <sstream>
#include <string>
#include <type_traits>

#include "musashi_msgs/msg/detail/motor_state__struct.hpp"
#include "rosidl_runtime_cpp/traits.hpp"

// Include directives for member types
// Member 'header'
#include "std_msgs/msg/detail/header__traits.hpp"

namespace musashi_msgs
{

namespace msg
{

inline void to_flow_style_yaml(
  const MotorState & msg,
  std::ostream & out)
{
  out << "{";
  // member: header
  {
    out << "header: ";
    to_flow_style_yaml(msg.header, out);
    out << ", ";
  }

  // member: motor_name
  {
    out << "motor_name: ";
    rosidl_generator_traits::value_to_yaml(msg.motor_name, out);
    out << ", ";
  }

  // member: position
  {
    out << "position: ";
    rosidl_generator_traits::value_to_yaml(msg.position, out);
    out << ", ";
  }

  // member: velocity
  {
    out << "velocity: ";
    rosidl_generator_traits::value_to_yaml(msg.velocity, out);
    out << ", ";
  }

  // member: current
  {
    out << "current: ";
    rosidl_generator_traits::value_to_yaml(msg.current, out);
  }
  out << "}";
}  // NOLINT(readability/fn_size)

inline void to_block_style_yaml(
  const MotorState & msg,
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

  // member: motor_name
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "motor_name: ";
    rosidl_generator_traits::value_to_yaml(msg.motor_name, out);
    out << "\n";
  }

  // member: position
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "position: ";
    rosidl_generator_traits::value_to_yaml(msg.position, out);
    out << "\n";
  }

  // member: velocity
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "velocity: ";
    rosidl_generator_traits::value_to_yaml(msg.velocity, out);
    out << "\n";
  }

  // member: current
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "current: ";
    rosidl_generator_traits::value_to_yaml(msg.current, out);
    out << "\n";
  }
}  // NOLINT(readability/fn_size)

inline std::string to_yaml(const MotorState & msg, bool use_flow_style = false)
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
  const musashi_msgs::msg::MotorState & msg,
  std::ostream & out, size_t indentation = 0)
{
  musashi_msgs::msg::to_block_style_yaml(msg, out, indentation);
}

[[deprecated("use musashi_msgs::msg::to_yaml() instead")]]
inline std::string to_yaml(const musashi_msgs::msg::MotorState & msg)
{
  return musashi_msgs::msg::to_yaml(msg);
}

template<>
inline const char * data_type<musashi_msgs::msg::MotorState>()
{
  return "musashi_msgs::msg::MotorState";
}

template<>
inline const char * name<musashi_msgs::msg::MotorState>()
{
  return "musashi_msgs/msg/MotorState";
}

template<>
struct has_fixed_size<musashi_msgs::msg::MotorState>
  : std::integral_constant<bool, false> {};

template<>
struct has_bounded_size<musashi_msgs::msg::MotorState>
  : std::integral_constant<bool, false> {};

template<>
struct is_message<musashi_msgs::msg::MotorState>
  : std::true_type {};

}  // namespace rosidl_generator_traits

#endif  // MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATE__TRAITS_HPP_
