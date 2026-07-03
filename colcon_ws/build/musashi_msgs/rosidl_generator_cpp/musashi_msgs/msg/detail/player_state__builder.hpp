// generated from rosidl_generator_cpp/resource/idl__builder.hpp.em
// with input from musashi_msgs:msg/PlayerState.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATE__BUILDER_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATE__BUILDER_HPP_

#include <algorithm>
#include <utility>

#include "musashi_msgs/msg/detail/player_state__struct.hpp"
#include "rosidl_runtime_cpp/message_initialization.hpp"


namespace musashi_msgs
{

namespace msg
{

namespace builder
{

class Init_PlayerState_obstacle
{
public:
  explicit Init_PlayerState_obstacle(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  ::musashi_msgs::msg::PlayerState obstacle(::musashi_msgs::msg::PlayerState::_obstacle_type arg)
  {
    msg_.obstacle = std::move(arg);
    return std::move(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_moveto
{
public:
  explicit Init_PlayerState_moveto(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  Init_PlayerState_obstacle moveto(::musashi_msgs::msg::PlayerState::_moveto_type arg)
  {
    msg_.moveto = std::move(arg);
    return Init_PlayerState_obstacle(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_position
{
public:
  explicit Init_PlayerState_position(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  Init_PlayerState_moveto position(::musashi_msgs::msg::PlayerState::_position_type arg)
  {
    msg_.position = std::move(arg);
    return Init_PlayerState_moveto(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_my_goal
{
public:
  explicit Init_PlayerState_my_goal(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  Init_PlayerState_position my_goal(::musashi_msgs::msg::PlayerState::_my_goal_type arg)
  {
    msg_.my_goal = std::move(arg);
    return Init_PlayerState_position(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_goal
{
public:
  explicit Init_PlayerState_goal(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  Init_PlayerState_my_goal goal(::musashi_msgs::msg::PlayerState::_goal_type arg)
  {
    msg_.goal = std::move(arg);
    return Init_PlayerState_my_goal(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_ball
{
public:
  explicit Init_PlayerState_ball(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  Init_PlayerState_goal ball(::musashi_msgs::msg::PlayerState::_ball_type arg)
  {
    msg_.ball = std::move(arg);
    return Init_PlayerState_goal(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_haveball
{
public:
  explicit Init_PlayerState_haveball(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  Init_PlayerState_ball haveball(::musashi_msgs::msg::PlayerState::_haveball_type arg)
  {
    msg_.haveball = std::move(arg);
    return Init_PlayerState_ball(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_role
{
public:
  explicit Init_PlayerState_role(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  Init_PlayerState_haveball role(::musashi_msgs::msg::PlayerState::_role_type arg)
  {
    msg_.role = std::move(arg);
    return Init_PlayerState_haveball(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_state
{
public:
  explicit Init_PlayerState_state(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  Init_PlayerState_role state(::musashi_msgs::msg::PlayerState::_state_type arg)
  {
    msg_.state = std::move(arg);
    return Init_PlayerState_role(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_action
{
public:
  explicit Init_PlayerState_action(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  Init_PlayerState_state action(::musashi_msgs::msg::PlayerState::_action_type arg)
  {
    msg_.action = std::move(arg);
    return Init_PlayerState_state(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_id
{
public:
  explicit Init_PlayerState_id(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  Init_PlayerState_action id(::musashi_msgs::msg::PlayerState::_id_type arg)
  {
    msg_.id = std::move(arg);
    return Init_PlayerState_action(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_color
{
public:
  explicit Init_PlayerState_color(::musashi_msgs::msg::PlayerState & msg)
  : msg_(msg)
  {}
  Init_PlayerState_id color(::musashi_msgs::msg::PlayerState::_color_type arg)
  {
    msg_.color = std::move(arg);
    return Init_PlayerState_id(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

class Init_PlayerState_header
{
public:
  Init_PlayerState_header()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  Init_PlayerState_color header(::musashi_msgs::msg::PlayerState::_header_type arg)
  {
    msg_.header = std::move(arg);
    return Init_PlayerState_color(msg_);
  }

private:
  ::musashi_msgs::msg::PlayerState msg_;
};

}  // namespace builder

}  // namespace msg

template<typename MessageType>
auto build();

template<>
inline
auto build<::musashi_msgs::msg::PlayerState>()
{
  return musashi_msgs::msg::builder::Init_PlayerState_header();
}

}  // namespace musashi_msgs

#endif  // MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATE__BUILDER_HPP_
