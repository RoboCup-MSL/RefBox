# generated from rosidl_generator_py/resource/_idl.py.em
# with input from musashi_msgs:msg/PlayerState.idl
# generated code does not contain a copyright notice


# Import statements for member types

import builtins  # noqa: E402, I100

import rosidl_parser.definition  # noqa: E402, I100


class Metaclass_PlayerState(type):
    """Metaclass of message 'PlayerState'."""

    _CREATE_ROS_MESSAGE = None
    _CONVERT_FROM_PY = None
    _CONVERT_TO_PY = None
    _DESTROY_ROS_MESSAGE = None
    _TYPE_SUPPORT = None

    __constants = {
    }

    @classmethod
    def __import_type_support__(cls):
        try:
            from rosidl_generator_py import import_type_support
            module = import_type_support('musashi_msgs')
        except ImportError:
            import logging
            import traceback
            logger = logging.getLogger(
                'musashi_msgs.msg.PlayerState')
            logger.debug(
                'Failed to import needed modules for type support:\n' +
                traceback.format_exc())
        else:
            cls._CREATE_ROS_MESSAGE = module.create_ros_message_msg__msg__player_state
            cls._CONVERT_FROM_PY = module.convert_from_py_msg__msg__player_state
            cls._CONVERT_TO_PY = module.convert_to_py_msg__msg__player_state
            cls._TYPE_SUPPORT = module.type_support_msg__msg__player_state
            cls._DESTROY_ROS_MESSAGE = module.destroy_ros_message_msg__msg__player_state

            from geometry_msgs.msg import Pose
            if Pose.__class__._TYPE_SUPPORT is None:
                Pose.__class__.__import_type_support__()

            from musashi_msgs.msg import Polar2D
            if Polar2D.__class__._TYPE_SUPPORT is None:
                Polar2D.__class__.__import_type_support__()

            from std_msgs.msg import Header
            if Header.__class__._TYPE_SUPPORT is None:
                Header.__class__.__import_type_support__()

    @classmethod
    def __prepare__(cls, name, bases, **kwargs):
        # list constant names here so that they appear in the help text of
        # the message class under "Data and other attributes defined here:"
        # as well as populate each message instance
        return {
        }


class PlayerState(metaclass=Metaclass_PlayerState):
    """Message class 'PlayerState'."""

    __slots__ = [
        '_header',
        '_color',
        '_id',
        '_action',
        '_state',
        '_role',
        '_haveball',
        '_ball',
        '_goal',
        '_my_goal',
        '_position',
        '_moveto',
        '_obstacle',
    ]

    _fields_and_field_types = {
        'header': 'std_msgs/Header',
        'color': 'int32',
        'id': 'int32',
        'action': 'int32',
        'state': 'int32',
        'role': 'int32',
        'haveball': 'int32',
        'ball': 'musashi_msgs/Polar2D',
        'goal': 'musashi_msgs/Polar2D',
        'my_goal': 'musashi_msgs/Polar2D',
        'position': 'geometry_msgs/Pose',
        'moveto': 'geometry_msgs/Pose',
        'obstacle': 'musashi_msgs/Polar2D',
    }

    SLOT_TYPES = (
        rosidl_parser.definition.NamespacedType(['std_msgs', 'msg'], 'Header'),  # noqa: E501
        rosidl_parser.definition.BasicType('int32'),  # noqa: E501
        rosidl_parser.definition.BasicType('int32'),  # noqa: E501
        rosidl_parser.definition.BasicType('int32'),  # noqa: E501
        rosidl_parser.definition.BasicType('int32'),  # noqa: E501
        rosidl_parser.definition.BasicType('int32'),  # noqa: E501
        rosidl_parser.definition.BasicType('int32'),  # noqa: E501
        rosidl_parser.definition.NamespacedType(['musashi_msgs', 'msg'], 'Polar2D'),  # noqa: E501
        rosidl_parser.definition.NamespacedType(['musashi_msgs', 'msg'], 'Polar2D'),  # noqa: E501
        rosidl_parser.definition.NamespacedType(['musashi_msgs', 'msg'], 'Polar2D'),  # noqa: E501
        rosidl_parser.definition.NamespacedType(['geometry_msgs', 'msg'], 'Pose'),  # noqa: E501
        rosidl_parser.definition.NamespacedType(['geometry_msgs', 'msg'], 'Pose'),  # noqa: E501
        rosidl_parser.definition.NamespacedType(['musashi_msgs', 'msg'], 'Polar2D'),  # noqa: E501
    )

    def __init__(self, **kwargs):
        assert all('_' + key in self.__slots__ for key in kwargs.keys()), \
            'Invalid arguments passed to constructor: %s' % \
            ', '.join(sorted(k for k in kwargs.keys() if '_' + k not in self.__slots__))
        from std_msgs.msg import Header
        self.header = kwargs.get('header', Header())
        self.color = kwargs.get('color', int())
        self.id = kwargs.get('id', int())
        self.action = kwargs.get('action', int())
        self.state = kwargs.get('state', int())
        self.role = kwargs.get('role', int())
        self.haveball = kwargs.get('haveball', int())
        from musashi_msgs.msg import Polar2D
        self.ball = kwargs.get('ball', Polar2D())
        from musashi_msgs.msg import Polar2D
        self.goal = kwargs.get('goal', Polar2D())
        from musashi_msgs.msg import Polar2D
        self.my_goal = kwargs.get('my_goal', Polar2D())
        from geometry_msgs.msg import Pose
        self.position = kwargs.get('position', Pose())
        from geometry_msgs.msg import Pose
        self.moveto = kwargs.get('moveto', Pose())
        from musashi_msgs.msg import Polar2D
        self.obstacle = kwargs.get('obstacle', Polar2D())

    def __repr__(self):
        typename = self.__class__.__module__.split('.')
        typename.pop()
        typename.append(self.__class__.__name__)
        args = []
        for s, t in zip(self.__slots__, self.SLOT_TYPES):
            field = getattr(self, s)
            fieldstr = repr(field)
            # We use Python array type for fields that can be directly stored
            # in them, and "normal" sequences for everything else.  If it is
            # a type that we store in an array, strip off the 'array' portion.
            if (
                isinstance(t, rosidl_parser.definition.AbstractSequence) and
                isinstance(t.value_type, rosidl_parser.definition.BasicType) and
                t.value_type.typename in ['float', 'double', 'int8', 'uint8', 'int16', 'uint16', 'int32', 'uint32', 'int64', 'uint64']
            ):
                if len(field) == 0:
                    fieldstr = '[]'
                else:
                    assert fieldstr.startswith('array(')
                    prefix = "array('X', "
                    suffix = ')'
                    fieldstr = fieldstr[len(prefix):-len(suffix)]
            args.append(s[1:] + '=' + fieldstr)
        return '%s(%s)' % ('.'.join(typename), ', '.join(args))

    def __eq__(self, other):
        if not isinstance(other, self.__class__):
            return False
        if self.header != other.header:
            return False
        if self.color != other.color:
            return False
        if self.id != other.id:
            return False
        if self.action != other.action:
            return False
        if self.state != other.state:
            return False
        if self.role != other.role:
            return False
        if self.haveball != other.haveball:
            return False
        if self.ball != other.ball:
            return False
        if self.goal != other.goal:
            return False
        if self.my_goal != other.my_goal:
            return False
        if self.position != other.position:
            return False
        if self.moveto != other.moveto:
            return False
        if self.obstacle != other.obstacle:
            return False
        return True

    @classmethod
    def get_fields_and_field_types(cls):
        from copy import copy
        return copy(cls._fields_and_field_types)

    @builtins.property
    def header(self):
        """Message field 'header'."""
        return self._header

    @header.setter
    def header(self, value):
        if __debug__:
            from std_msgs.msg import Header
            assert \
                isinstance(value, Header), \
                "The 'header' field must be a sub message of type 'Header'"
        self._header = value

    @builtins.property
    def color(self):
        """Message field 'color'."""
        return self._color

    @color.setter
    def color(self, value):
        if __debug__:
            assert \
                isinstance(value, int), \
                "The 'color' field must be of type 'int'"
            assert value >= -2147483648 and value < 2147483648, \
                "The 'color' field must be an integer in [-2147483648, 2147483647]"
        self._color = value

    @builtins.property  # noqa: A003
    def id(self):  # noqa: A003
        """Message field 'id'."""
        return self._id

    @id.setter  # noqa: A003
    def id(self, value):  # noqa: A003
        if __debug__:
            assert \
                isinstance(value, int), \
                "The 'id' field must be of type 'int'"
            assert value >= -2147483648 and value < 2147483648, \
                "The 'id' field must be an integer in [-2147483648, 2147483647]"
        self._id = value

    @builtins.property
    def action(self):
        """Message field 'action'."""
        return self._action

    @action.setter
    def action(self, value):
        if __debug__:
            assert \
                isinstance(value, int), \
                "The 'action' field must be of type 'int'"
            assert value >= -2147483648 and value < 2147483648, \
                "The 'action' field must be an integer in [-2147483648, 2147483647]"
        self._action = value

    @builtins.property
    def state(self):
        """Message field 'state'."""
        return self._state

    @state.setter
    def state(self, value):
        if __debug__:
            assert \
                isinstance(value, int), \
                "The 'state' field must be of type 'int'"
            assert value >= -2147483648 and value < 2147483648, \
                "The 'state' field must be an integer in [-2147483648, 2147483647]"
        self._state = value

    @builtins.property
    def role(self):
        """Message field 'role'."""
        return self._role

    @role.setter
    def role(self, value):
        if __debug__:
            assert \
                isinstance(value, int), \
                "The 'role' field must be of type 'int'"
            assert value >= -2147483648 and value < 2147483648, \
                "The 'role' field must be an integer in [-2147483648, 2147483647]"
        self._role = value

    @builtins.property
    def haveball(self):
        """Message field 'haveball'."""
        return self._haveball

    @haveball.setter
    def haveball(self, value):
        if __debug__:
            assert \
                isinstance(value, int), \
                "The 'haveball' field must be of type 'int'"
            assert value >= -2147483648 and value < 2147483648, \
                "The 'haveball' field must be an integer in [-2147483648, 2147483647]"
        self._haveball = value

    @builtins.property
    def ball(self):
        """Message field 'ball'."""
        return self._ball

    @ball.setter
    def ball(self, value):
        if __debug__:
            from musashi_msgs.msg import Polar2D
            assert \
                isinstance(value, Polar2D), \
                "The 'ball' field must be a sub message of type 'Polar2D'"
        self._ball = value

    @builtins.property
    def goal(self):
        """Message field 'goal'."""
        return self._goal

    @goal.setter
    def goal(self, value):
        if __debug__:
            from musashi_msgs.msg import Polar2D
            assert \
                isinstance(value, Polar2D), \
                "The 'goal' field must be a sub message of type 'Polar2D'"
        self._goal = value

    @builtins.property
    def my_goal(self):
        """Message field 'my_goal'."""
        return self._my_goal

    @my_goal.setter
    def my_goal(self, value):
        if __debug__:
            from musashi_msgs.msg import Polar2D
            assert \
                isinstance(value, Polar2D), \
                "The 'my_goal' field must be a sub message of type 'Polar2D'"
        self._my_goal = value

    @builtins.property
    def position(self):
        """Message field 'position'."""
        return self._position

    @position.setter
    def position(self, value):
        if __debug__:
            from geometry_msgs.msg import Pose
            assert \
                isinstance(value, Pose), \
                "The 'position' field must be a sub message of type 'Pose'"
        self._position = value

    @builtins.property
    def moveto(self):
        """Message field 'moveto'."""
        return self._moveto

    @moveto.setter
    def moveto(self, value):
        if __debug__:
            from geometry_msgs.msg import Pose
            assert \
                isinstance(value, Pose), \
                "The 'moveto' field must be a sub message of type 'Pose'"
        self._moveto = value

    @builtins.property
    def obstacle(self):
        """Message field 'obstacle'."""
        return self._obstacle

    @obstacle.setter
    def obstacle(self, value):
        if __debug__:
            from musashi_msgs.msg import Polar2D
            assert \
                isinstance(value, Polar2D), \
                "The 'obstacle' field must be a sub message of type 'Polar2D'"
        self._obstacle = value
