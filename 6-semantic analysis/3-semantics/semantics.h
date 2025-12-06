#pragma once

#include<iostream>
#include<string>
#include<map>
#include<sstream>

enum type {
    integer,
    boolean,
};

struct var_data {
	int decl_row;
	type decl_type;
	var_data(){}
	var_data(int i, type t)
	{
		decl_row = i;
		decl_type = t;
	}
};

extern std::string type_name(type t);
