%option noyywrap c++ yylineno

%{
#include <iostream>
#include <cstdlib>
%}


WS  [ \t\n]

%%

^"*".*              std::cout << "Comment: " << YYText() << std::endl;

PROGRAM             std::cout << "Key: " << YYText() << std::endl;
DATA                std::cout << "Key: " << YYText() << std::endl;
:                   std::cout << "Key: " << YYText() << std::endl;

WHILE               std::cout << "Key: " << YYText() << std::endl;
ENDWHILE            std::cout << "Key: " << YYText() << std::endl;

IF                  std::cout << "Key: " << YYText() << std::endl;
ELSE                std::cout << "Key: " << YYText() << std::endl;
ENDIF               std::cout << "Key: " << YYText() << std::endl;

TYPE                std::cout << "Key: " << YYText() << std::endl;

READ                std::cout << "Key: " << YYText() << std::endl;
WRITE               std::cout << "Key: " << YYText() << std::endl;
TO                  std::cout << "Key: " << YYText() << std::endl;
FROM                std::cout << "Key: " << YYText() << std::endl;
BY                  std::cout << "Key: " << YYText() << std::endl;

MOVE                std::cout << "Key: " << YYText() << std::endl;

ADD                 std::cout << "Arithmetic: " << YYText() << std::endl;
SUBTRACT            std::cout << "Arithmetic: " << YYText() << std::endl;
MULTIPLY            std::cout << "Arithmetic: " << YYText() << std::endl;
DIVIDE              std::cout << "Arithmetic: " << YYText() << std::endl;
MOD                 std::cout << "Arithmetic: " << YYText() << std::endl;
"+"                 std::cout << "Arithmetic: " << YYText() << std::endl;
"-"                 std::cout << "Arithmetic: " << YYText() << std::endl;

">"                 std::cout << "Logic: " << YYText() << std::endl;
"<"                 std::cout << "Logic: " << YYText() << std::endl;
"="                 std::cout << "Logic: " << YYText() << std::endl;
NOT                 std::cout << "Logic: " << YYText() << std::endl;
AND                 std::cout << "Logic: " << YYText() << std::endl;
OR                  std::cout << "Logic: " << YYText() << std::endl;


"("                 std::cout << "Open: " << YYText() << std::endl;
")"                 std::cout << "Close: " << YYText() << std::endl;

I                   std::cout << "Type: " << YYText() << std::endl;
B                   std::cout << "Type: " << YYText() << std::endl;

[a-z]+([0-9_a-z])*  std::cout << "Variable: " << YYText() << std::endl;

[0-9]+              std::cout << "Integer value: " << YYText() << std::endl;

TRUE                std::cout << "True value: " << YYText() << std::endl;
FALSE               std::cout << "False value: " << YYText() << std::endl;


{WS}+       // feher szokozok: semmi teendo

,           std::cout << "Separator: " << YYText() << std::endl;
"."         std::cout << "End command: " << YYText() << std::endl;
.           {
                std::cerr << lineno() << ": Lexikalis hiba." << std::endl;
                exit(1);
            }

%%