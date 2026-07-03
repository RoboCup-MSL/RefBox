// generated from rosidl_generator_cpp/resource/idl__builder.hpp.em
// with input from musashi_msgs:msg/PlayerStates.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__BUILDER_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__BUILDER_HPP_

#include <algorithm>
#include <utility>

#include "musashi_msgs/msg/detail/player_states__struct.hpp"
#include "rosidl_runtime_cpp/message_initialization.hpp"


namespace musashi_msgs
{

namespace msg
{

namespace builder
{

class Init_PlayerStates_players
{
public:
  explicit Init_PlayerStates_players(::musashi_msgs::msg::PlayerStates & msg)
  : msg_(msg)
  {}
  ::musashi_msgs::msg::PlayerStates players(::musashi_msgs::msg::PlayerStates::_players_type arg)
  {
    msg_.players = std::move(arg);
    return std::move(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerStates msg_;
};

class Init_PlayerStates_header
{
public:
  Init_PlayerStates_header()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  Init_PlayerStates_players header(::musashi_msgs::msg::PlayerStates::_header_type arg)
  {
    msg_.header = std::move(arg);
    return Init_PlayerStates_players(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerStates msg_;
};

}  // namespace builder

}  // namespace msg

template<typename MessageType>
auto build();

template<>
inline
auto build<::musashi_msgs::msg::PlayerStates>()
{
  return musashi_msgs::msg::builder::Init_PlayerStates_header();
}

}  // namespace musashi_msgs

#endif  // MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATES__BUILDER_HPP_
