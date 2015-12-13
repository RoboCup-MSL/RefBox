/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                                                                           *
 *  FILE : ConfigXML.h                                                       *
 *                                                                           *
 *  Copyright 2012 CAMBADA Team, All Rights Reserved                         *
 *  DET/IEETA, University of Aveiro, http://www.ieeta.pt/atri/cambada        *
 *                                                                           *
 *  Created by Ricardo Dias (ricardodias@ua.pt)                              *
 *                                                                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#ifndef _CONFIGXML_H_
#define _CONFIGXML_H_

#include <iostream>
#include <map>
#include <vector>

#include "Param.h"
#include "field.conf.hxx"

using namespace std;

class ConfigXML
{
    private:
        map<string,Param> parameter;
		map<string,int> field;
	
	public:
		ConfigXML();
		~ConfigXML();
	
        bool parse(string fileName);

        float getParam(string name);
		int getField(string name);

        map<string,Param>::iterator getParamMapBegin();
        map<string,Param>::iterator getParamMapEnd();
        bool addParam(string name,Param *par);
        bool addParam(string name,float val); // Retro-compatibility
        bool removeParam(string name);
        bool existParam(string name);

        bool updateParam(string name,Param *par);
        bool updateParam(string name, float val); // Retro-compatibility

		map<string,int>::iterator getFieldMapBegin();
		map<string,int>::iterator getFieldMapEnd();
		bool addField(string name, int value);
		bool removeField(string name);
		bool existField(string name);
		bool updateField(string name, int value);

		bool write(string fileName);
	
		void display();

	protected:
		bool retValue;
};
#endif //_CONFIGXML2_H_

