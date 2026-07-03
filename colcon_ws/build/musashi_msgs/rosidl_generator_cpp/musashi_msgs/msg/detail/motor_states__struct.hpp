// generated from rosidl_generator_cpp/resource/idl__struct.hpp.em
// with input from musashi_msgs:msg/MotorStates.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__STRUCT_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__STRUCT_HPP_

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
// Member 'states'
#include "musashi_msgs/msg/detail/motor_state__struct.hpp"

#ifndef _WIN32
# define DEPRECATED__musashi_msgs__msg__MotorStates __attribute__((deprecated))
#else
# define DEPRECATED__musashi_msgs__msg__MotorStates __declspec(deprecated)
#endif

namespace musashi_msgs
{

namespace msg
{

// message struct
template<class ContainerAllocator>
struct MotorStates_
{
  using Type = MotorStates_<ContainerAllocator>;

  explicit MotorStates_(rosidl_runtime_cpp::MessageInitialization _init = rosidl_runtime_cpp::MessageInitialization::ALL)
  : header(_init)
  {
    (void)_init;
  }

  explicit MotorStates_(const ContainerAllocator & _alloc, rosidl_runtime_cpp::MessageInitialization _init = rosidl_runtime_cpp::MessageInitialization::ALL)
  : header(_alloc, _init)
  {
    (void)_init;
  }

  // field types and members
  using _header_type =
    std_msgs::msg::Header_<ContainerAllocator>;
  _header_type header;
  using _states_type =
    std::vector<musashi_msgs::msg::MotorState_<ContainerAllocator>, typename std::allocator_traits<ContainerAllocator>::template rebind_alloc<musashi_msgs::msg::MotorState_<ContainerAllocator>>>;
  _states_type states;

  // setters for named parameter idiom
  Type & set__header(
    const std_msgs::msg::Header_<ContainerAllocator> & _arg)
  {
    this->header = _arg;
    return *this;
  }
  Type & set__states(
    const std::vector<musashi_msgs::msg::MotorState_<ContainerAllocator>, typename std::allocator_traits<ContainerAllocator>::template rebind_alloc<musashi_msgs::msg::MotorState_<ContainerAllocator>>> & _arg)
  {
    this->states = _arg;
    return *this;
  }

  // constant declarations

  // pointer types
  using RawPtr =
    musashi_msgs::msg::MotorStates_<ContainerAllocator> *;
  using ConstRawPtr =
    const musashi_msgs::msg::MotorStates_<ContainerAllocator> *;
  using SharedPtr =
    std::shared_ptr<musashi_msgs::msg::MotorStates_<ContainerAllocator>>;
  using ConstSharedPtr =
    std::shared_ptr<musashi_msgs::msg::MotorStates_<ContainerAllocator> const>;

  template<typename Deleter = std::default_delete<
      musashi_msgs::msg::MotorStates_<ContainerAllocator>>>
  using UniquePtrWithDeleter =
    std::unique_ptr<musashi_msgs::msg::MotorStates_<ContainerAllocator>, Deleter>;

  using UniquePtr = UniquePtrWithDeleter<>;

  template<typename Deleter = std::default_delete<
      musashi_msgs::msg::MotorStates_<ContainerAllocator>>>
  using ConstUniquePtrWithDeleter =
    std::unique_ptr<musashi_msgs::msg::MotorStates_<ContainerAllocator> const, Deleter>;
  using ConstUniquePtr = ConstUniquePtrWithDeleter<>;

  using WeakPtr =
    std::weak_ptr<musashi_msgs::msg::MotorStates_<ContainerAllocator>>;
  using ConstWeakPtr =
    std::weak_ptr<musashi_msgs::msg::MotorStates_<ContainerAllocator> const>;

  // pointer types similar to ROS 1, use SharedPtr / ConstSharedPtr instead
  // NOTE: Can't use 'using' here because GNU C++ can't parse attributes properly
  typedef DEPRECATED__musashi_msgs__msg__MotorStates
    std::shared_ptr<musashi_msgs::msg::MotorStates_<ContainerAllocator>>
    Ptr;
  typedef DEPRECATED__musashi_msgs__msg__MotorStates
    std::shared_ptr<musashi_msgs::msg::MotorStates_<ContainerAllocator> const>
    ConstPtr;

  // comparison operators
  bool operator==(const MotorStates_ & other) const
  {
    if (this->header != other.header) {
      return false;
    }
    if (this->states != other.states) {
      return false;
    }
    return true;
  }
  bool operator!=(const MotorStates_ & other) const
  {
    return !this->operator==(other);
  }
};  // struct MotorStates_

// alias to use template instance with default allocator
using MotorStates =
  musashi_msgs::msg::MotorStates_<std::allocator<void>>;

// constant definitions

}  // namespace msg

}  // namespace musashi_msgs

#endif  // MUSASHI_MSGS__MSG__DETAIL__MOTOR_STATES__STRUCT_HPP_
