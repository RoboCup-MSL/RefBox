// generated from rosidl_generator_cpp/resource/idl__traits.hpp.em
// with input from musashi_msgs:msg/PlayerStates.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__TRAITS_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__TRAITS_HPP_

#include <stdint.h>

#include <sstream>
#include <string>
#include <type_traits>

#include "musashi_msgs/msg/detail/player_states__struct.hpp"
#include "rosidl_runtime_cpp/traits.hpp"

// Include directives for member types
// Member 'header'
#include "std_msgs/msg/detail/header__traits.hpp"
// Member 'players'
#include "musashi_msgs/msg/detail/player_state__traits.hpp"

namespace musashi_msgs
{

namespace msg
{

inline void to_flow_style_yaml(
  const PlayerStates & msg,
  std::ostream & out)
{
  out << "{";
  // member: header
  {
    out << "header: ";
    to_flow_style_yaml(msg.header, out);
    out << ", ";
  }

  // member: players
  {
    if (msg.players.size() == 0) {
      out << "players: []";
    } else {
      out << "players: [";
      size_t pending_items = msg.players.size();
      for (auto item : msg.players) {
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
  const PlayerStates & msg,
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

  // member: players
  {
    if (indentation > 0) {
      out << std::string(indentation, ' ');
    }
    if (msg.players.size() == 0) {
      out << "players: []\n";
    } else {
      out << "players:\n";
      for (auto item : msg.players) {
        if (indentation > 0) {
          out << std::string(indentation, ' ');
        }
        out << "-\n";
        to_block_style_yaml(item, out, indentation + 2);
      }
    }
  }
}  // NOLINT(readability/fn_size)

inline std::string to_yaml(const PlayerStates & msg, bool use_flow_style = false)
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
  const musashi_msgs::msg::PlayerStates & msg,
  std::ostream & out, size_t indentation = 0)
{
  musashi_msgs::msg::to_block_style_yaml(msg, out, indentation);
}

[[deprecated("use musashi_msgs::msg::to_yaml() instead")]]
inline std::string to_yaml(const musashi_msgs::msg::PlayerStates & msg)
{
  return musashi_msgs::msg::to_yaml(msg);
}

template<>
inline const char * data_type<musashi_msgs::msg::PlayerStates>()
{
  return "musashi_msgs::msg::PlayerStates";
}

template<>
inline const char * name<musashi_msgs::msg::PlayerStates>()
{
  return "musashi_msgs/msg/PlayerStates";
}

template<>
struct has_fixed_size<musashi_msgs::msg::PlayerStates>
  : std::integral_constant<bool, has_fixed_size<musashi_msgs::msg::PlayerState>::value && has_fixed_size<std_msgs::msg::Header>::value> {};

template<>
struct has_bounded_size<musashi_msgs::msg::PlayerStates>
  : std::integral_constant<bool, has_bounded_size<musashi_msgs::msg::PlayerState>::value && has_bounded_size<std_msgs::msg::Header>::value> {};

template<>
struct is_message<musashi_msgs::msg::PlayerStates>
  : std::true_type {};

}  // namespace rosidl_generator_traits

#endif  // MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__TRAITS_HPP_
