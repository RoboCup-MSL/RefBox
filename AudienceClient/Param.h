#ifndef _PARAM_H_
#define _PARAM_H_

#include <stdio.h>
#include <iostream>

using namespace std;

class Param
{
public:
    Param( float value , string comment, string timestamp);
    Param( float value );
    Param();
	
	float value;
	string comment;
	string timestamp;
};

#endif // _PARAM_H_
