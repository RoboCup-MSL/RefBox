/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *                                                                           *
 *  FILE : ConfigXML.cpp                                                     *
 *                                                                           *
 *  Copyright 2012 CAMBADA Team, All Rights Reserved                         *
 *  DET/IEETA, University of Aveiro, http://www.ieeta.pt/atri/cambada        *
 *                                                                           *
 *  Created by Ricardo Dias (ricardodias@ua.pt)                              *
 *                                                                           *
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

#include "ConfigXML.h"
#include <syslog.h>
#include <assert.h>

using namespace std;

ConfigXML::ConfigXML( )
{
	retValue = true;
}

ConfigXML::~ConfigXML()
{
}

bool ConfigXML::parse(string fileName)
{
    auto_ptr<FieldConfig> fieldConf;
	try
	{
        fieldConf = FieldConfig_(fileName);
	}
	catch(const exception& ex)
//	catch(...)
	{
		cerr << "ConfigXML exception ... " << ex.what() << endl;
		return false;
	}

    for (unsigned int i = 0; i < fieldConf->Field().size(); ++i)
	{
        field[fieldConf->Field()[i].name()] = fieldConf->Field()[i].value();
	}

    for (unsigned int i = 0; i < fieldConf->Parameter().size(); ++i)
	{
        parameter[fieldConf->Parameter()[i].name()].value = fieldConf->Parameter()[i].value();
		
        std::string cmt = fieldConf->Parameter()[i].comment();
		//fprintf(stderr,"Comment: %s\n",cmt.c_str());
		
        parameter[fieldConf->Parameter()[i].name()].comment = cmt;
	}

	return retValue;
}

float ConfigXML::getParam(string name)
{
	if( parameter.count(name) == 0 )
	{
		syslog(LOG_ERR,"ConfigXML (getParam) %s",name.data() );	
		assert( parameter.count(name) != 0 );
	}

	return parameter[name].value;
}
	
int ConfigXML::getField(string name)
{
	if( field.count(name) == 0 )
	{
		syslog(LOG_ERR,"ConfigXML (getField) %s",name.data());	
		assert( field.count(name) != 0 );
	}
	
	return field[name];
}

map<string,Param>::iterator ConfigXML::getParamMapBegin()
{
	return parameter.begin();
}

map<string,Param>::iterator ConfigXML::getParamMapEnd()
{
	return parameter.end();
}

map<string,int>::iterator ConfigXML::getFieldMapBegin()
{
	return field.begin();
}

map<string,int>::iterator ConfigXML::getFieldMapEnd()
{
	return field.end();
}

bool ConfigXML::addParam(string name, Param *par)
{
	parameter.insert(pair<string,Param>(name,*par));

	if(parameter.count(name)!=0)
		return true;
	else
		return false;
}

bool ConfigXML::addParam(string name, float val)
{
	parameter.insert(pair<string,Param>(name, Param(val)));

	if(parameter.count(name)!=0)
		return true;
	else
		return false;
}

bool ConfigXML::removeParam(string name)
{
	if(parameter.count(name)!=0)
		parameter.erase(name);

	return true;
}

bool ConfigXML::addField(string name, int value)
{
	field.insert(pair<string,int>(name,value));

	if(field.count(name)!=0)
		return true;
	else
		return false;
}

bool ConfigXML::removeField(string name)
{
	if(field.count(name)!=0)
		field.erase(name);

	return true;
}

bool ConfigXML::existParam(string name)
{
	if(parameter.count(name)==0)
		return false;
	else
		return true;
}

bool ConfigXML::existField(string name)
{
	if(field.count(name)==0)
		return false;
	else
		return true;
}

bool ConfigXML::updateParam(string name, Param *par)
{
	if(existParam(name))
	{
		parameter[name]=*par;
		return true;
	}
	else
		return false;
}

bool ConfigXML::updateParam(string name, float val)
{
	if(existParam(name))
	{
		Param *p = new Param(val);
		parameter[name]=*p;
		return true;
	}
	else
		return false;
}

bool ConfigXML::updateField(string name, int value)
{
	if(existField(name))
	{
		field[name]=value;
		return true;
	}
	else
		return false;
}

bool ConfigXML::write(string fileName)	
{
	cout << "{ConfigXML] : file name " << fileName <<endl;
	cout << "{ConfigXML] : field size " << field.size() <<endl;
	cout << "{ConfigXML] : parameter size " << parameter.size() <<endl;
	FILE* fp = fopen(fileName.c_str(),"w");
	//FILE* fp = fopen("tmp.xml","w");
	
	if( fp == NULL )
		return false;
	
	fprintf(fp,"<CambadaConfig version=\"1.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:noNamespaceSchemaLocation=\"cambada.conf.xsd\">\n\n\n");
	
	for( map<string,int>::iterator it = field.begin(); it != field.end() ; it++)
		fprintf(fp,"\t<Field name=\"%s\" value=\"%d\"/>\n", it->first.c_str() , it->second);
	
	fprintf(fp,"\n\n");
	
	for( map<string,Param>::iterator it = parameter.begin(); it != parameter.end() ; it++)
		fprintf(fp,"\t<Parameter name=\"%s\" value=\"%f\" comment=\"%s\"/>\n", it->first.c_str() , it->second.value, it->second.comment.c_str());
			
	fprintf(fp,"\n\n");

	fprintf(fp,"\n</CambadaConfig>\n");
		
	fclose(fp);
	
			
	return true;
}

void ConfigXML::display()
{
    cout << "{ConfigXML] : field size " << field.size() <<endl;
	cout << "{ConfigXML] : parameter size " << parameter.size() <<endl;
	
	printf("<CambadaConfig version=\"1.0\">\n\n\n");
	
	for( map<string,int>::iterator it = field.begin(); it != field.end() ; it++)
		printf("\t<Field name=\"%s\" value=\"%d\"/>\n", it->first.c_str() , it->second);
	
	printf("\n\n");
	
	for( map<string,Param>::iterator it = parameter.begin(); it != parameter.end() ; it++)
		printf("\t<Parameter name=\"%s\" value=\"%f\" comment=\"%s\"/>\n", it->first.c_str() , it->second.value, it->second.comment.c_str());
			
	printf("\n\n");
				
	printf("\n</CambadaConfig>\n");
		
}

