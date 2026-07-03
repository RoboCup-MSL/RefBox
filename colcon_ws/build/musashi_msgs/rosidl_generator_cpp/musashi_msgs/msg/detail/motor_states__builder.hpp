// generated from rosidl_generator_cpp/resource/idl__builder.hpp.em
// with input from musashi_msgs:msg/MotorStates.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__BUILDER_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__BUILDER_HPP_

#include <algorithm>
#include <utility>

#include "musashi_msgs/msg/detail/motor_states__struct.hpp"
#include "rosidl_runtime_cpp/message_initialization.hpp"


namespace musashi_msgs
{

namespace msg
{

namespace builder
{

class Init_MotorStates_states
{
public:
  explicit Init_MotorStates_states(::musashi_msgs::msg::MotorStates & msg)
  : msg_(msg)
  {}
  ::musashi_msgs::msg::MotorStates states(::musashi_msgs::msg::MotorStates::_states_type arg)
  {
    msg_.states = std::move(arg);
    return std::move(msg_);
  }

private:
  ::musashi_msgs::msg::MotorStates msg_;
};

class Init_MotorStates_header
{
public:
  Init_MotorStates_header()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  Init_MotorStates_states header(::musashi_msgs::msg::MotorStates::_header_type arg)
  {
    msg_.header = std::move(arg);
    return Init_MotorStates_states(msg_);
  }

private:
  ::musashi_msgs::msg::MotorStates msg_;
};

}  // namespace builder

}  // namespace msg

template<typename MessageType>
auto build();

template<>
inline
auto build<::musashi_msgs::msg::MotorStates>()
{
  return musashi_msgs::msg::builder::Init_MotorStates_header();
}

}  // namespace musashi_msgs

#endif  // MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__BUILDER_HPP_
