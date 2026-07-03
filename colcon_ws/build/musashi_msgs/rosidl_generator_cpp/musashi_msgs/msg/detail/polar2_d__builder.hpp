// generated from rosidl_generator_cpp/resource/idl__builder.hpp.em
// with input from musashi_msgs:msg/Polar2D.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__BUILDER_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__BUILDER_HPP_

#include <algorithm>
#include <utility>

#include "musashi_msgs/msg/detail/polar2_d__struct.hpp"
#include "rosidl_runtime_cpp/message_initialization.hpp"


namespace musashi_msgs
{

namespace msg
{

namespace builder
{

class Init_Polar2D_angle
{
public:
  explicit Init_Polar2D_angle(::musashi_msgs::msg::Polar2D & msg)
  : msg_(msg)
  {}
  ::musashi_msgs::msg::Polar2D angle(::musashi_msgs::msg::Polar2D::_angle_type arg)
  {
    msg_.angle = std::move(arg);
    return std::move(msg_);
  }

private:
  ::musashi_msgs::msg::Polar2D msg_;
};

class Init_Polar2D_distance
{
public:
  Init_Polar2D_distance()
  : msg_(::rosidl_runtime_cpp::MessageInitialization::SKIP)
  {}
  Init_Polar2D_angle distance(::musashi_msgs::msg::Polar2D::_distance_type arg)
  {
    msg_.distance = std::move(arg);
    return Init_Polar2D_angle(msg_);
  }

private:
  ::musashi_msgs::msg::Polar2D msg_;
};

}  // namespace builder

}  // namespace msg

template<typename MessageType>
auto build();

template<>
inline
auto build<::musashi_msgs::msg::Polar2D>()
{
  return musashi_msgs::msg::builder::Init_Polar2D_distance();
}

}  // namespace musashi_msgs

#endif  // MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__BUILDER_HPP_
