#include "Param.h"

Param::Param( float value, string comment, string timestamp )
{
	this->value = value;
	this->comment = comment;
	this->timestamp = timestamp;
}

Param::Param( float value )
{
	this->value = value;
	this->comment = "";
	this->timestamp = "";
}

Param::Param()
{
	this->value = 0.0;
	this->comment = "";
	this->timestamp = "";
}
