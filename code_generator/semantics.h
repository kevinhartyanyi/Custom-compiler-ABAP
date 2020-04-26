#ifndef SEMANTICS_H
#define SEMANTICS_H

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

struct expr_data
{
    int row;
    type var_type;
    std::string code;
    expr_data(int s, type t, std::string k ) 
        : row(s), var_type(t), code(k) {}
    expr_data() {}
};

struct instr_data
{
    int row;
    std::string code;
    instr_data( int s, std::string k )
        : row(s), code(k) {} 
};

#endif //SEMANTICS_H