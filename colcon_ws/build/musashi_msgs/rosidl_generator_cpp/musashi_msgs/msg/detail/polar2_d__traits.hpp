// generated from rosidl_generator_cpp/resource/idl__traits.hpp.em
// with input from musashi_msgs:msg/Polar2D.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__TRAITS_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__TRAITS_HPP_

#include <stdint.h>

#include <sstream>
#include <string>
#include <type_traits>

#include "musashi_msgs/msg/detail/polar2_d__struct.hpp"
#include "rosidl_runtime_cpp/traits.hpp"

namespace musashi_msgs
{

namespace msg
{

inline void to_flow_style_yaml(
  const Polar2D & msg,
  std::ostream & out)
{
  out << "{";
  // member: distance
  {
    out << "distance: ";
    rosidl_generator_traits::value_to_yaml(msg.distance, out);
    out << ", ";
  }

  // member: angle
  {
    out << "angle: ";
    rosidl_generator_traits::value_to_yaml(msg.angle, out);
  }
  out << "}";
}  // NOLINT(readability/fn_size)

inline void to_block_style_yaml(
  const Polar2D & msg,
  std::ostream & out, size_t indentation = 0)
{
  // member: distance
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "distance: ";
    rosidl_generator_traits::value_to_yaml(msg.distance, out);
    out << "\n";
  }

  // member: angle
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    out << "angle: ";
    rosidl_generator_traits::value_to_yaml(msg.angle, out);
    out << "\n";
  }
}  // NOLINT(readability/fn_size)

inline std::string to_yaml(const Polar2D & msg, bool use_flow_style = false)
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
  const musashi_msgs::msg::Polar2D & msg,
  std::ostream & out, size_t indentation = 0)
{
  musashi_msgs::msg::to_block_style_yaml(msg, out, indentation);
}

[[deprecated("use musashi_msgs::msg::to_yaml() instead")]]
inline std::string to_yaml(const musashi_msgs::msg::Polar2D & msg)
{
  return musashi_msgs::msg::to_yaml(msg);
}

template<>
inline const char * data_type<musashi_msgs::msg::Polar2D>()
{
  return "musashi_msgs::msg::Polar2D";
}

template<>
inline const char * name<musashi_msgs::msg::Polar2D>()
{
  return "musashi_msgs/msg/Polar2D";
}

template<>
struct has_fixed_size<musashi_msgs::msg::Polar2D>
  : std::integral_constant<bool, true> {};

template<>
struct has_bounded_size<musashi_msgs::msg::Polar2D>
  : std::integral_constant<bool, true> {};

template<>
struct is_message<musashi_msgs::msg::Polar2D>
  : std::true_type {};

}  // namespace rosidl_generator_traits

#endif  // MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__TRAITS_HPP_
