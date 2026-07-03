// generated from rosidl_generator_cpp/resource/idl__builder.hpp.em
// with input from musashi_msgs:msg/MotorState.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATE__BUILDER_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATE__BUILDER_HPP_

#include <algorithm>
#include <utility>

#include "musashi_msgs/msg/detail/motor_state__struct.hpp"
#include "rosidl_runtime_cpp/message_initialization.hpp"


namespace musashi_msgs
{

namespace msg
{

namespace builder
{

class Init_MotorState_current
{
public:
  explicit Init_MotorState_current(::musashi_msgs::msg::MotorState & msg)
  : msg_(msg)
  {}
  ::musashi_msgs::msg::MotorState current(::musashi_msgs::msg::MotorState::_current_type arg)
  {
    msg_.current = std::move(arg);
    return std::move(msg_);
  }

private:
  ::musashi_msgs::msg::MotorState msg_;
};

class Init_MotorState_velocity
{
public:
  explicit Init_MotorState_velocity(::musashi_msgs::msg::MotorState & msg)
  : msg_(msg)
  {}
  Init_MotorState_current velocity(::musashi_msgs::msg::MotorState::_velocity_type arg)
  {
    msg_.velocity = std::move(arg);
    return Init_MotorState_current(msg_);
  }

private:
  ::musashi_msgs::msg::MotorState msg_;
};

class Init_MotorState_position
{
public:
  explicit Init_MotorState_position(::musashi_msgs::msg::MotorState & msg)
  : msg_(msg)
  {}
  Init_MotorState_velocity position(::musashi_msgs::msg::MotorState::_position_type arg)
  {
    msg_.position = std::move(arg);
    return Init_MotorState_velocity(msg_);
  }

private:
  ::musashi_msgs::msg::MotorState msg_;
};

class Init_MotorState_motor_name
{
public:
  explicit Init_MotorState_motor_name(::musashi_msgs::msg::MotorState & msg)
  : msg_(msg)
  {}
  Init_MotorState_position motor_name(::musashi_msgs::msg::MotorState::_motor_name_type arg)
  {
    msg_.motor_name = std::move(arg);
    return Init_MotorState_position(msg_);
  }

private:
  ::musashi_msgs::msg::MotorState msg_;
};

class Init_MotorState_header
{
public:
  Init_MotorState_header()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  Init_MotorState_motor_name header(::musashi_msgs::msg::MotorState::_header_type arg)
  {
    msg_.header = std::move(arg);
    return Init_MotorState_motor_name(msg_);
  }

private:
  ::musashi_msgs::msg::MotorState msg_;
};

}  // namespace builder

}  // namespace msg

template<typename MessageType>
auto build();

template<>
inline
auto build<::musashi_msgs::msg::MotorState>()
{
  return musashi_msgs::msg::builder::Init_MotorState_header();
}

}  // namespace musashi_msgs

#endif  // MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATE__BUILDER_HPP_
