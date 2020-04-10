#include <iostream>
#include <string>
#include <map>
#include <sstream>

enum type {natural, boolean};

struct var_data
{
    int decl_row;
    type var_type;

    var_data() {}
    var_data(int d_row, type v_type): 
        decl_row(d_row), var_type(v_type) {}
};
