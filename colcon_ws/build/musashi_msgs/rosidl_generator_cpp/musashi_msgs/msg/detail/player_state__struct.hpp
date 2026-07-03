// generated from rosidl_generator_cpp/resource/idl__struct.hpp.em
// with input from musashi_msgs:msg/PlayerState.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATE__STRUCT_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATE__STRUCT_HPP_

#include <algorithm>
#include <array>
#include <memory>
#include <string>
#include <vector>

#include "rosidl_runtime_cpp/bounded_vector.hpp"
#include "rosidl_runtime_cpp/message_initialization.hpp"


// Include directives for member types
// Member 'header'
#include "std_msgs/msg/detail/header__struct.hpp"
// Member 'ball'
// Member 'goal'
// Member 'my_goal'
// Member 'obstacle'
#include "musashi_msgs/msg/detail/polar2_d__struct.hpp"
// Member 'position'
// Member 'moveto'
#include "geometry_msgs/msg/detail/pose__struct.hpp"

#ifndef _WIN32
# define DEPRECATED__musashi_msgs__msg__PlayerState __attribute__((deprecated))
#else
# define DEPRECATED__musashi_msgs__msg__PlayerState __declspec(deprecated)
#endif

namespace musashi_msgs
{

namespace msg
{

// message struct
template<class ContainerAllocator>
struct PlayerState_
{
  using Type = PlayerState_<ContainerAllocator>;

  explicit PlayerState_(rosidl_runtime_cpp::MessageInitialization _init = rosidl_runtime_cpp::MessageInitialization::ALL)
  : header(_init),
    ball(_init),
    goal(_init),
    my_goal(_init),
    position(_init),
    moveto(_init),
    obstacle(_init)
  {
    if (rosidl_runtime_cpp::MessageInitialization::ALL == _init ||
      rosidl_runtime_cpp::MessageInitialization::ZERO == _init)
    {
      this->color = 0l;
      this->id = 0l;
      this->action = 0l;
      this->state = 0l;
      this->role = 0l;
      this->haveball = 0l;
    }
  }

  explicit PlayerState_(const ContainerAllocator & _alloc, rosidl_runtime_cpp::MessageInitialization _init = rosidl_runtime_cpp::MessageInitialization::ALL)
  : header(_alloc, _init),
    ball(_alloc, _init),
    goal(_alloc, _init),
    my_goal(_alloc, _init),
    position(_alloc, _init),
    moveto(_alloc, _init),
    obstacle(_alloc, _init)
  {
    if (rosidl_runtime_cpp::MessageInitialization::ALL == _init ||
      rosidl_runtime_cpp::MessageInitialization::ZERO == _init)
    {
      this->color = 0l;
      this->id = 0l;
      this->action = 0l;
      this->state = 0l;
      this->role = 0l;
      this->haveball = 0l;
    }
  }

  // field types and members
  using _header_type =
    std_msgs::msg::Header_<ContainerAllocator>;
  _header_type header;
  using _color_type =
    int32_t;
  _color_type color;
  using _id_type =
    int32_t;
  _id_type id;
  using _action_type =
    int32_t;
  _action_type action;
  using _state_type =
    int32_t;
  _state_type state;
  using _role_type =
    int32_t;
  _role_type role;
  using _haveball_type =
    int32_t;
  _haveball_type haveball;
  using _ball_type =
    musashi_msgs::msg::Polar2D_<ContainerAllocator>;
  _ball_type ball;
  using _goal_type =
    musashi_msgs::msg::Polar2D_<ContainerAllocator>;
  _goal_type goal;
  using _my_goal_type =
    musashi_msgs::msg::Polar2D_<ContainerAllocator>;
  _my_goal_type my_goal;
  using _position_type =
    geometry_msgs::msg::Pose_<ContainerAllocator>;
  _position_type position;
  using _moveto_type =
    geometry_msgs::msg::Pose_<ContainerAllocator>;
  _moveto_type moveto;
  using _obstacle_type =
    musashi_msgs::msg::Polar2D_<ContainerAllocator>;
  _obstacle_type obstacle;

  // setters for named parameter idiom
  Type & set__header(
    const std_msgs::msg::Header_<ContainerAllocator> & _arg)
  {
    this->header = _arg;
    return *this;
  }
  Type & set__color(
    const int32_t & _arg)
  {
    this->color = _arg;
    return *this;
  }
  Type & set__id(
    const int32_t & _arg)
  {
    this->id = _arg;
    return *this;
  }
  Type & set__action(
    const int32_t & _arg)
  {
    this->action = _arg;
    return *this;
  }
  Type & set__state(
    const int32_t & _arg)
  {
    this->state = _arg;
    return *this;
  }
  Type & set__role(
    const int32_t & _arg)
  {
    this->role = _arg;
    return *this;
  }
  Type & set__haveball(
    const int32_t & _arg)
  {
    this->haveball = _arg;
    return *this;
  }
  Type & set__ball(
    const musashi_msgs::msg::Polar2D_<ContainerAllocator> & _arg)
  {
    this->ball = _arg;
    return *this;
  }
  Type & set__goal(
    const musashi_msgs::msg::Polar2D_<ContainerAllocator> & _arg)
  {
    this->goal = _arg;
    return *this;
  }
  Type & set__my_goal(
    const musashi_msgs::msg::Polar2D_<ContainerAllocator> & _arg)
  {
    this->my_goal = _arg;
    return *this;
  }
  Type & set__position(
    const geometry_msgs::msg::Pose_<ContainerAllocator> & _arg)
  {
    this->position = _arg;
    return *this;
  }
  Type & set__moveto(
    const geometry_msgs::msg::Pose_<ContainerAllocator> & _arg)
  {
    this->moveto = _arg;
    return *this;
  }
  Type & set__obstacle(
    const musashi_msgs::msg::Polar2D_<ContainerAllocator> & _arg)
  {
    this->obstacle = _arg;
    return *this;
  }

  // constant declarations

  // pointer types
  using RawPtr =
    musashi_msgs::msg::PlayerState_<ContainerAllocator> *;
  using ConstRawPtr =
    const musashi_msgs::msg::PlayerState_<ContainerAllocator> *;
  using SharedPtr =
    std::shared_ptr<musashi_msgs::msg::PlayerState_<ContainerAllocator>>;
  using ConstSharedPtr =
    std::shared_ptr<musashi_msgs::msg::PlayerState_<ContainerAllocator> const>;

  template<typename Deleter = std::default_delete<
      musashi_msgs::msg::PlayerState_<ContainerAllocator>>>
  using UniquePtrWithDeleter =
    std::unique_ptr<musashi_msgs::msg::PlayerState_<ContainerAllocator>, Deleter>;

  using UniquePtr = UniquePtrWithDeleter<>;

  template<typename Deleter = std::default_delete<
      musashi_msgs::msg::PlayerState_<ContainerAllocator>>>
  using ConstUniquePtrWithDeleter =
    std::unique_ptr<musashi_msgs::msg::PlayerState_<ContainerAllocator> const, Deleter>;
  using ConstUniquePtr = ConstUniquePtrWithDeleter<>;

  using WeakPtr =
    std::weak_ptr<musashi_msgs::msg::PlayerState_<ContainerAllocator>>;
  using ConstWeakPtr =
    std::weak_ptr<musashi_msgs::msg::PlayerState_<ContainerAllocator> const>;

  // pointer types similar to ROS 1, use SharedPtr / ConstSharedPtr instead
  // NOTE: Can't use 'using' here because GNU C++ can't parse attributes properly
  typedef DEPRECATED__musashi_msgs__msg__PlayerState
    std::shared_ptr<musashi_msgs::msg::PlayerState_<ContainerAllocator>>
    Ptr;
  typedef DEPRECATED__musashi_msgs__msg__PlayerState
    std::shared_ptr<musashi_msgs::msg::PlayerState_<ContainerAllocator> const>
    ConstPtr;

  // comparison operators
  bool operator==(const PlayerState_ & other) const
  {
    if (this->header != other.header) {
      return false;
    }
    if (this->color != other.color) {
      return false;
    }
    if (this->id != other.id) {
      return false;
    }
    if (this->action != other.action) {
      return false;
    }
    if (this->state != other.state) {
      return false;
    }
    if (this->role != other.role) {
      return false;
    }
    if (this->haveball != other.haveball) {
      return false;
    }
    if (this->ball != other.ball) {
      return false;
    }
    if (this->goal != other.goal) {
      return false;
    }
    if (this->my_goal != other.my_goal) {
      return false;
    }
    if (this->position != other.position) {
      return false;
    }
    if (this->moveto != other.moveto) {
      return false;
    }
    if (this->obstacle != other.obstacle) {
      return false;
    }
    return true;
  }
  bool operator!=(const PlayerState_ & other) const
  {
    return !this->operator==(other);
  }
};  // struct PlayerState_

// alias to use template instance with default allocator
using PlayerState =
  musashi_msgs::msg::PlayerState_<std::allocator<void>>;

// constant definitions

}  // namespace msg

}  // namespace musashi_msgs

#endif  // MUSASHI_MSGS__MSG__DETAIL__PLAYER_STATE__STRUCT_HPP_
