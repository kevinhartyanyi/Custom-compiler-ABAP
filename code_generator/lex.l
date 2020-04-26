%option noyywrap c++ yylineno

%{
#include "Parserbase.h"
%}

WS  [ \t\n]

%%

^"*".*              std::cout << ";Comment: " << YYText() << std::endl;

PROGRAM             return Parser::PROGRAM;
DATA                return Parser::DATA;
:                   return Parser::DDOT;

WHILE               return Parser::WHILE;
ENDWHILE            return Parser::ENDWHILE;

IF                  return Parser::IF;
ELSE                return Parser::ELSE;
ENDIF               return Parser::ENDIF;

TYPE                return Parser::TYPE;

READ                return Parser::READ;
WRITE               return Parser::WRITE;
TO                  return Parser::TO;
FROM                return Parser::FROM;
BY                  return Parser::BY;

MOVE                return Parser::MOVE;
ADD                 return Parser::ADD;
SUBTRACT            return Parser::SUBTRACT;

MULTIPLY            return Parser::MULTIPLY;
DIVIDE              return Parser::DIVIDE;
MOD                 return Parser::MOD;
"+"                 return Parser::PLUS;
"-"                 return Parser::MINUS;

">"                 return Parser::BIGGER;
"<"                 return Parser::SMALLER;
"="                 return Parser::EQUAL;
NOT                 return Parser::NOT;
AND                 return Parser::AND;
OR                  return Parser::OR;


"("                 return Parser::OPEN;
")"                 return Parser::CLOSE;

I                   return Parser::INT;
B                   return Parser::BOOL;

[a-z]+([0-9_a-z])*  return Parser::VAR;

[0-9]+              return Parser::NUM;

TRUE                return Parser::TRUE;
FALSE               return Parser::FALSE;


{WS}+       // feher szokozok: semmi teendo

,           return Parser::SEPARATOR;
"."         return Parser::END;
.           {
                std::cerr << lineno() << ": Lexikalis hiba." << std::endl;
                exit(1);
            }

%%
