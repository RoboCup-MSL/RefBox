// generated from rosidl_generator_cpp/resource/idl__traits.hpp.em
// with input from musashi_msgs:msg/RefereeCmd.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__TRAITS_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__TRAITS_HPP_

#include <stdint.h>

#include <sstream>
#include <string>
#include <type_traits>

#include "musashi_msgs/msg/detail/referee_cmd__struct.hpp"
#include "rosidl_runtime_cpp/traits.hpp"

// Include directives for member types
// Member 'header'
#include "std_msgs/msg/detail/header__traits.hpp"

namespace musashi_msgs
{

namespace msg
{

inline void to_flow_style_yaml(
  const RefereeCmd & msg,
  std::ostream & out)
{
  out << "{";
  // member: header
  {
    out << "header: ";
    to_flow_style_yaml(msg.header, out);
    out << ", ";
  }

  // member: command
  {
    out << "command: ";
    rosidl_generator_traits::value_to_yaml(msg.command, out);
    out << ", ";
  }

  // member: target_team
  {
    out << "target_team: ";
    rosidl_generator_traits::value_to_yaml(msg.target_team, out);
  }
  out << "}";
}  // NOLINT(readability/fn_size)

inline void to_block_style_yaml(
  const RefereeCmd & msg,
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

  // member: command
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "command: ";
    rosidl_generator_traits::value_to_yaml(msg.command, out);
    out << "\n";
  }

  // member: target_team
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "target_team: ";
    rosidl_generator_traits::value_to_yaml(msg.target_team, out);
    out << "\n";
  }
}  // NOLINT(readability/fn_size)

inline std::string to_yaml(const RefereeCmd & msg, bool use_flow_style = false)
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
  const musashi_msgs::msg::RefereeCmd & msg,
  std::ostream & out, size_t indentation = 0)
{
  musashi_msgs::msg::to_block_style_yaml(msg, out, indentation);
}

[[deprecated("use musashi_msgs::msg::to_yaml() instead")]]
inline std::string to_yaml(const musashi_msgs::msg::RefereeCmd & msg)
{
  return musashi_msgs::msg::to_yaml(msg);
}

template<>
inline const char * data_type<musashi_msgs::msg::RefereeCmd>()
{
  return "musashi_msgs::msg::RefereeCmd";
}

template<>
inline const char * name<musashi_msgs::msg::RefereeCmd>()
{
  return "musashi_msgs/msg/RefereeCmd";
}

template<>
struct has_fixed_size<musashi_msgs::msg::RefereeCmd>
  : std::integral_constant<bool, false> {};

template<>
struct has_bounded_size<musashi_msgs::msg::RefereeCmd>
  : std::integral_constant<bool, false> {};

template<>
struct is_message<musashi_msgs::msg::RefereeCmd>
  : std::true_type {};

}  // namespace rosidl_generator_traits

#endif  // MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__TRAITS_HPP_
