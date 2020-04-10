%baseclass-preinclude <iostream>
%lsp-needed

%token PROGRAM DATA DDOT
%token WHILE ENDWHILE
%token IF ELSE ENDIF
%token TYPE
%token READ WRITE TO FROM BY
%token MOVE
//%token ADD SUBTRACT
//%token MULTIPLY DIVIDE MOD PLUS MINUS
//%token BIGGER SMALLER EQUAL NOT AND OR
%token OPEN CLOSE
%token INT BOOL
%token VAR
%token NUM
%token TRUE FALSE
%token SEPARATOR
%token END


%token ADD SUBTRACT PLUS MINUS
%token MULTIPLY DIVIDE MOD

%left OR
%left AND
%right NOT

%left EQUAL
%left SMALLER BIGGER

%%

start:
    PROGRAM VAR END declaration
    {
        std::cout << "start -> PROGRAM VAR END declaration" << std::endl;
    }
;

declaration:
    body
    {
        std::cout << "declaration -> body" << std::endl;
    }
|
    DATA DDOT vardeclaration body
    {
        std::cout << "declaration -> DATA DDOT vardeclaration body" << std::endl;
    }
;

vardeclaration:
    VAR TYPE INT SEPARATOR vardeclaration
    {
        std::cout << "vardeclaration -> VAR TYPE INT SEPARATOR vardeclaration" << std::endl;
    }
|
    VAR TYPE BOOL SEPARATOR vardeclaration
    {
        std::cout << "vardeclaration -> VAR TYPE BOOL SEPARATOR vardeclaration" << std::endl;
    }
|
    VAR TYPE INT END
    {
        std::cout << "vardeclaration -> VAR TYPE INT END" << std::endl;
    }
|
    VAR TYPE BOOL END
    {
        std::cout << "vardeclaration -> VAR TYPE BOOL END" << std::endl;
    }
;

body:
    //empty
    {
        std::cout << "body -> empty" << std::endl;
    }
|
    sequence
    {
        std::cout << "body -> sequence" << std::endl;
    }
;

sequence:
    statement sequence
    {
        std::cout << "sequence -> statement sequence" << std::endl;
    }
|
    statement
    {
        std::cout << "sequence -> statement" << std::endl;
    }
;

statement:
    MOVE expression TO VAR END
    {
        std::cout << "sequence -> MOVE expression TO VAR END" << std::endl;
    }
|
    arithmetic END
    {
        std::cout << "sequence -> arithmetic END" << std::endl;
    }
|
    WRITE expression END
    {
        std::cout << "sequence -> WRITE expression END" << std::endl;
    }    
|
    WHILE logic END sequence ENDWHILE END
    {
        std::cout << "sequence -> WHILE logic END sequence ENDWHILE" << std::endl;
    }
|
    READ TO VAR END
    {
        std::cout << "sequence -> READ TO VAR END" << std::endl;
    }
|
    IF logic END sequence ENDIF END
    {
        std::cout << "sequence -> IF logic END sequence ENDIF END" << std::endl;
    }
|
    IF logic END sequence ELSE END sequence ENDIF END
    {
        std::cout << "sequence -> IF logic END sequence ELSE END sequence ENDIF END" << std::endl;
    }
;


logic:
	expression
    {
        std::cout << "logic -> expression" << std::endl;
    }
|
	logic EQUAL logic
    {
        std::cout << "logic -> logic EQUAL logic" << std::endl;
    }
|
	logic OR logic
    {
        std::cout << "logic -> logic OR logic" << std::endl;
    }
|
	logic AND logic
    {
        std::cout << "logic -> logic AND logic" << std::endl;
    }
|
	NOT logic
    {
        std::cout << "logic -> NOT logic" << std::endl;
    }
|
	logic SMALLER EQUAL logic
    {
        std::cout << "logic -> logic SMALLER EQUAL logic" << std::endl;
    }
|
	logic BIGGER EQUAL logic
    {
        std::cout << "logic -> logic BIGGER EQUAL logic" << std::endl;
    }
|
	logic SMALLER logic
    {
        std::cout << "logic -> logic SMALLER logic" << std::endl;
    }
|
	logic BIGGER logic
    {
        std::cout << "logic -> logic BIGGER logic" << std::endl;
    }
|
    OPEN logic CLOSE
    {
        std::cout << "logic -> OPEN logic CLOSE" << std::endl;
    }
;

expression:
    VAR
    {
        std::cout << "expression -> VAR" << std::endl;
    }
|
    NUM
    {
        std::cout << "expression -> NUM" << std::endl;
    }
|
    TRUE
    {
        std::cout << "expression -> TRUE" << std::endl;
    }
|
    FALSE
    {
        std::cout << "expression -> FALSE" << std::endl;
    }
;

arithmetic:
    SUBTRACT expression FROM VAR
    {
        std::cout << "arithmetic -> SUBTRACT expression FROM VAR" << std::endl;
    }
|
    ADD expression TO VAR
    {
        std::cout << "arithmetic -> ADD expression TO VAR END sequence" << std::endl;
    }
|
    MULTIPLY VAR BY expression
    {
        std::cout << "arithmetic -> MULTIPLY VAR BY expression" << std::endl;
    }
|
    DIVIDE VAR BY expression
    {
        std::cout << "arithmetic -> DIVIDE VAR BY expression" << std::endl;
    }
|
    MOD VAR BY expression TO VAR
    {
        std::cout << "arithmetic -> MOD VAR BY expression TO VAR" << std::endl;
    }
;



