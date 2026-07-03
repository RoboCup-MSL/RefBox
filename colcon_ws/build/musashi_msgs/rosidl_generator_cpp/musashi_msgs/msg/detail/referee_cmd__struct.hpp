// generated from rosidl_generator_cpp/resource/idl__struct.hpp.em
// with input from musashi_msgs:msg/RefereeCmd.idl
// generated code does not contain a copyright notice

#ifndef MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__STRUCT_HPP_
#define MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__STRUCT_HPP_

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

#ifndef _WIN32
# define DEPRECATED__musashi_msgs__msg__RefereeCmd __attribute__((deprecated))
#else
# define DEPRECATED__musashi_msgs__msg__RefereeCmd __declspec(deprecated)
#endif

namespace musashi_msgs
{

namespace msg
{

// message struct
template<class ContainerAllocator>
struct RefereeCmd_
{
  using Type = RefereeCmd_<ContainerAllocator>;

  explicit RefereeCmd_(rosidl_runtime_cpp::MessageInitialization _init = rosidl_runtime_cpp::MessageInitialization::ALL)
  : header(_init)
  {
    if (rosidl_runtime_cpp::MessageInitialization::ALL == _init ||
      rosidl_runtime_cpp::MessageInitialization::ZERO == _init)
    {
      this->command = "";
      this->target_team = "";
    }
  }

  explicit RefereeCmd_(const ContainerAllocator & _alloc, rosidl_runtime_cpp::MessageInitialization _init = rosidl_runtime_cpp::MessageInitialization::ALL)
  : header(_alloc, _init),
    command(_alloc),
    target_team(_alloc)
  {
    if (rosidl_runtime_cpp::MessageInitialization::ALL == _init ||
      rosidl_runtime_cpp::MessageInitialization::ZERO == _init)
    {
      this->command = "";
      this->target_team = "";
    }
  }

  // field types and members
  using _header_type =
    std_msgs::msg::Header_<ContainerAllocator>;
  _header_type header;
  using _command_type =
    std::basic_string<char, std::char_traits<char>, typename std::allocator_traits<ContainerAllocator>::template rebind_alloc<char>>;
  _command_type command;
  using _target_team_type =
    std::basic_string<char, std::char_traits<char>, typename std::allocator_traits<ContainerAllocator>::template rebind_alloc<char>>;
  _target_team_type target_team;

  // setters for named parameter idiom
  Type & set__header(
    const std_msgs::msg::Header_<ContainerAllocator> & _arg)
  {
    this->header = _arg;
    return *this;
  }
  Type & set__command(
    const std::basic_string<char, std::char_traits<char>, typename std::allocator_traits<ContainerAllocator>::template rebind_alloc<char>> & _arg)
  {
    this->command = _arg;
    return *this;
  }
  Type & set__target_team(
    const std::basic_string<char, std::char_traits<char>, typename std::allocator_traits<ContainerAllocator>::template rebind_alloc<char>> & _arg)
  {
    this->target_team = _arg;
    return *this;
  }

  // constant declarations

  // pointer types
  using RawPtr =
    musashi_msgs::msg::RefereeCmd_<ContainerAllocator> *;
  using ConstRawPtr =
    const musashi_msgs::msg::RefereeCmd_<ContainerAllocator> *;
  using SharedPtr =
    std::shared_ptr<musashi_msgs::msg::RefereeCmd_<ContainerAllocator>>;
  using ConstSharedPtr =
    std::shared_ptr<musashi_msgs::msg::RefereeCmd_<ContainerAllocator> const>;

  template<typename Deleter = std::default_delete<
      musashi_msgs::msg::RefereeCmd_<ContainerAllocator>>>
  using UniquePtrWithDeleter =
    std::unique_ptr<musashi_msgs::msg::RefereeCmd_<ContainerAllocator>, Deleter>;

  using UniquePtr = UniquePtrWithDeleter<>;

  template<typename Deleter = std::default_delete<
      musashi_msgs::msg::RefereeCmd_<ContainerAllocator>>>
  using ConstUniquePtrWithDeleter =
    std::unique_ptr<musashi_msgs::msg::RefereeCmd_<ContainerAllocator> const, Deleter>;
  using ConstUniquePtr = ConstUniquePtrWithDeleter<>;

  using WeakPtr =
    std::weak_ptr<musashi_msgs::msg::RefereeCmd_<ContainerAllocator>>;
  using ConstWeakPtr =
    std::weak_ptr<musashi_msgs::msg::RefereeCmd_<ContainerAllocator> const>;

  // pointer types similar to ROS 1, use SharedPtr / ConstSharedPtr instead
  // NOTE: Can't use 'using' here because GNU C++ can't parse attributes properly
  typedef DEPRECATED__musashi_msgs__msg__RefereeCmd
    std::shared_ptr<musashi_msgs::msg::RefereeCmd_<ContainerAllocator>>
    Ptr;
  typedef DEPRECATED__musashi_msgs__msg__RefereeCmd
    std::shared_ptr<musashi_msgs::msg::RefereeCmd_<ContainerAllocator> const>
    ConstPtr;

  // comparison operators
  bool operator==(const RefereeCmd_ & other) const
  {
    if (this->header != other.header) {
      return false;
    }
    if (this->command != other.command) {
      return false;
    }
    if (this->target_team != other.target_team) {
      return false;
    }
    return true;
  }
  bool operator!=(const RefereeCmd_ & other) const
  {
    return !this->operator==(other);
  }
};  // struct RefereeCmd_

// alias to use template instance with default allocator
using RefereeCmd =
  musashi_msgs::msg::RefereeCmd_<std::allocator<void>>;

// constant definitions

}  // namespace msg

}  // namespace musashi_msgs

#endif  // MUSASHI_MSGS__MSG__DETAIL__REFEREE_CMD__STRUCT_HPP_
