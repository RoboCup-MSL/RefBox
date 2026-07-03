// generated from rosidl_generator_cpp/resource/idl__builder.hpp.em
// with input from musashi_msgs:msg/RefereeCmd.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__BUILDER_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__BUILDER_HPP_

#include <algorithm>
#include <utility>

#include "musashi_msgs/msg/detail/referee_cmd__struct.hpp"
#include "rosidl_runtime_cpp/message_initialization.hpp"


namespace musashi_msgs
{

namespace msg
{

namespace builder
{

class Init_RefereeCmd_target_team
{
public:
  explicit Init_RefereeCmd_target_team(::musashi_msgs::msg::RefereeCmd & msg)
  : msg_(msg)
  {}
  ::musashi_msgs::msg::RefereeCmd target_team(::musashi_msgs::msg::RefereeCmd::_target_team_type arg)
  {
    msg_.target_team = std::move(arg);
    return std::move(msg_);
  }

private:
  ::musashi_msgs::msg::RefereeCmd msg_;
};

class Init_RefereeCmd_command
{
public:
  explicit Init_RefereeCmd_command(::musashi_msgs::msg::RefereeCmd & msg)
  : msg_(msg)
  {}
  Init_RefereeCmd_target_team command(::musashi_msgs::msg::RefereeCmd::_command_type arg)
  {
    msg_.command = std::move(arg);
    return Init_RefereeCmd_target_team(msg_);
  }

private:
  ::musashi_msgs::msg::RefereeCmd msg_;
};

class Init_RefereeCmd_header
{
public:
  Init_RefereeCmd_header()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  Init_RefereeCmd_command header(::musashi_msgs::msg::RefereeCmd::_header_type arg)
  {
    msg_.header = std::move(arg);
    return Init_RefereeCmd_command(msg_);
  }

private:
  ::musashi_msgs::msg::RefereeCmd msg_;
};

}  // namespace builder

}  // namespace msg

template<typename MessageType>
auto build();

template<>
inline
auto build<::musashi_msgs::msg::RefereeCmd>()
{
  return musashi_msgs::msg::builder::Init_RefereeCmd_header();
}

}  // namespace musashi_msgs

#endif  // MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__BUILDER_HPP_
