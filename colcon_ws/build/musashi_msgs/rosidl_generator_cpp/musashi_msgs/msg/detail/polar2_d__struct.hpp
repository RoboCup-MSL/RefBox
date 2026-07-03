// generated from rosidl_generator_cpp/resource/idl__struct.hpp.em
// with input from musashi_msgs:msg/Polar2D.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__STRUCT_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__STRUCT_HPP_

#include <algorithm>
#include <array>
#include <memory>
#include <string>
#include <vector>

#include "rosidl_runtime_cpp/bounded_vector.hpp"
#include "rosidl_runtime_cpp/message_initialization.hpp"


#ifndef _WIN32
# define DEPRECATED__musashi_msgs__msg__Polar2D __attribute__((deprecated))
#else
# define DEPRECATED__musashi_msgs__msg__Polar2D __declspec(deprecated)
#endif

namespace musashi_msgs
{

namespace msg
{

// message struct
template<class ContainerAllocator>
struct Polar2D_
{
  using Type = Polar2D_<ContainerAllocator>;

  explicit Polar2D_(rosidl_runtime_cpp::MessageInitialization _init = rosidl_runtime_cpp::MessageInitialization::ALL)
  {
    if (rosidl_runtime_cpp::MessageInitialization::ALL == _init ||
      rosidl_runtime_cpp::MessageInitialization::ZERO == _init)
    {
      this->distance = 0.0f;
      this->angle = 0.0f;
    }
  }

  explicit Polar2D_(const ContainerAllocator & _alloc, rosidl_runtime_cpp::MessageInitialization _init = rosidl_runtime_cpp::MessageInitialization::ALL)
  {
    (void)_alloc;
    if (rosidl_runtime_cpp::MessageInitialization::ALL == _init ||
      rosidl_runtime_cpp::MessageInitialization::ZERO == _init)
    {
      this->distance = 0.0f;
      this->angle = 0.0f;
    }
  }

  // field types and members
  using _distance_type =
    float;
  _distance_type distance;
  using _angle_type =
    float;
  _angle_type angle;

  // setters for named parameter idiom
  Type & set__distance(
    const float & _arg)
  {
    this->distance = _arg;
    return *this;
  }
  Type & set__angle(
    const float & _arg)
  {
    this->angle = _arg;
    return *this;
  }

  // constant declarations

  // pointer types
  using RawPtr =
    musashi_msgs::msg::Polar2D_<ContainerAllocator> *;
  using ConstRawPtr =
    const musashi_msgs::msg::Polar2D_<ContainerAllocator> *;
  using SharedPtr =
    std::shared_ptr<musashi_msgs::msg::Polar2D_<ContainerAllocator>>;
  using ConstSharedPtr =
    std::shared_ptr<musashi_msgs::msg::Polar2D_<ContainerAllocator> const>;

  template<typename Deleter = std::default_delete<
      musashi_msgs::msg::Polar2D_<ContainerAllocator>>>
  using UniquePtrWithDeleter =
    std::unique_ptr<musashi_msgs::msg::Polar2D_<ContainerAllocator>, Deleter>;

  using UniquePtr = UniquePtrWithDeleter<>;

  template<typename Deleter = std::default_delete<
      musashi_msgs::msg::Polar2D_<ContainerAllocator>>>
  using ConstUniquePtrWithDeleter =
    std::unique_ptr<musashi_msgs::msg::Polar2D_<ContainerAllocator> const, Deleter>;
  using ConstUniquePtr = ConstUniquePtrWithDeleter<>;

  using WeakPtr =
    std::weak_ptr<musashi_msgs::msg::Polar2D_<ContainerAllocator>>;
  using ConstWeakPtr =
    std::weak_ptr<musashi_msgs::msg::Polar2D_<ContainerAllocator> const>;

  // pointer types similar to ROS 1, use SharedPtr / ConstSharedPtr instead
  // NOTE: Can't use 'using' here because GNU C++ can't parse attributes properly
  typedef DEPRECATED__musashi_msgs__msg__Polar2D
    std::shared_ptr<musashi_msgs::msg::Polar2D_<ContainerAllocator>>
    Ptr;
  typedef DEPRECATED__musashi_msgs__msg__Polar2D
    std::shared_ptr<musashi_msgs::msg::Polar2D_<ContainerAllocator> const>
    ConstPtr;

  // comparison operators
  bool operator==(const Polar2D_ & other) const
  {
    if (this->distance != other.distance) {
      return false;
    }
    if (this->angle != other.angle) {
      return false;
    }
    return true;
  }
  bool operator!=(const Polar2D_ & other) const
  {
    return !this->operator==(other);
  }
};  // struct Polar2D_

// alias to use template instance with default allocator
using Polar2D =
  musashi_msgs::msg::Polar2D_<std::allocator<void>>;

// constant definitions

}  // namespace msg

}  // namespace musashi_msgs

#endif  // MUSASHI_MSGS__MSG__DETAIL__POLAR2_D__STRUCT_HPP_
