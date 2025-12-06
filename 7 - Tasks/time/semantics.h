#pragma once

#include<iostream>
#include<string>
#include<map>
#include<sstream>

enum type {
    integer,
    boolean,
	time_type
};

struct var_data {
	int decl_row;
	type decl_type;
	bool assigned;
	var_data(){
		assigned = false;
	}
	var_data(int i, type t)
	{
		decl_row = i;
		decl_type = t;
		assigned = false;
	}
};

extern std::string type_name(type t);
