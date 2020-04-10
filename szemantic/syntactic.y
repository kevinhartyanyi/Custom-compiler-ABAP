%baseclass-preinclude "semantics.h"
%lsp-needed

%union
{
    std::string* szoveg;
    type* tipus;
}

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
%token <szoveg> VAR
%token NUM
%token TRUE FALSE
%token SEPARATOR
%token END


%token ADD SUBTRACT PLUS MINUS
%token MULTIPLY DIVIDE MOD

%type <tipus> expression
%type <tipus> logic

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
        std::cout << "Változó deklaráció: " << *$2 << std::endl;
        if( szimbolumtabla.count(*$2) > 0 )
        {
            std::stringstream ss;
            ss << "Ujradeklaralt valtozo: " << *$2 << ".\n"
            << "Korabbi deklaracio sora: " << szimbolumtabla[*$2].decl_row << std::endl;
            error( ss.str().c_str() );
        }
        szimbolumtabla[*$2] = var_data(
            d_loc__.first_line, natural
        );
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
        std::cout << "Változó deklaráció: " << *$1 << std::endl;
        if( szimbolumtabla.count(*$1) > 0 )
        {
            std::stringstream ss;
            ss << "Ujradeklaralt valtozo: " << *$1 << ".\n"
            << "Korabbi deklaracio sora: " << szimbolumtabla[*$1].decl_row << std::endl;
            error( ss.str().c_str() );
        }
        szimbolumtabla[*$1] = var_data(
            d_loc__.first_line, natural
        );
    }
|
    VAR TYPE BOOL SEPARATOR vardeclaration
    {
        std::cout << "vardeclaration -> VAR TYPE BOOL SEPARATOR vardeclaration" << std::endl;
        std::cout << "Változó deklaráció: " << *$1 << std::endl;
        if( szimbolumtabla.count(*$1) > 0 )
        {
            std::stringstream ss;
            ss << "Ujradeklaralt valtozo: " << *$1 << ".\n"
            << "Korabbi deklaracio sora: " << szimbolumtabla[*$1].decl_row << std::endl;
            error( ss.str().c_str() );
        }
        szimbolumtabla[*$1] = var_data(
            d_loc__.first_line, boolean
        );
    }
|
    VAR TYPE INT END
    {
        std::cout << "vardeclaration -> VAR TYPE INT END" << std::endl;
        std::cout << "Változó deklaráció: " << *$1 << std::endl;
        if( szimbolumtabla.count(*$1) > 0 )
        {
            std::stringstream ss;
            ss << "Ujradeklaralt valtozo: " << *$1 << ".\n"
            << "Korabbi deklaracio sora: " << szimbolumtabla[*$1].decl_row << std::endl;
            error( ss.str().c_str() );
        }
        szimbolumtabla[*$1] = var_data(
            d_loc__.first_line, natural
        );
    }
|
    VAR TYPE BOOL END
    {
        std::cout << "vardeclaration -> VAR TYPE BOOL END" << std::endl;
        std::cout << "Változó deklaráció: " << *$1 << std::endl;
        if( szimbolumtabla.count(*$1) > 0 )
        {
            std::stringstream ss;
            ss << "Ujradeklaralt valtozo: " << *$1 << ".\n"
            << "Korabbi deklaracio sora: " << szimbolumtabla[*$1].decl_row << std::endl;
            error( ss.str().c_str() );
        }
        szimbolumtabla[*$1] = var_data(
            d_loc__.first_line, boolean
        );
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
        if( szimbolumtabla.count(*$4) == 0 )
        {
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$4 << ".\n" << std::endl;
            error( ss.str().c_str() );
        }

        if(*$2 != szimbolumtabla[*$4].var_type)
        {
            error("Tipushibas ertekadas.\n");
        }

        delete $4;
        delete $2;
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
        if(*$2 != boolean)
        {
            error("Tipushibas IF.\n");
        }  
        delete $2;
    }
|
    READ TO VAR END
    {
        std::cout << "sequence -> READ TO VAR END" << std::endl;
        if( szimbolumtabla.count(*$3) == 0 )
        {
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$3 << ".\n" << std::endl;
            error( ss.str().c_str() );
        }
    }
|
    IF logic END sequence ENDIF END
    {
        std::cout << "sequence -> IF logic END sequence ENDIF END" << std::endl;
        if(*$2 != boolean)
        {
            error("Tipushibas IF.\n");
        }  
        delete $2;
    }
|
    IF logic END sequence ELSE END sequence ENDIF END
    {
        std::cout << "sequence -> IF logic END sequence ELSE END sequence ENDIF END" << std::endl;
        if(*$2 != boolean)
        {
            error("Tipushibas IF.\n");
        }  
        delete $2;
    }
;


logic:
	expression
    {
        std::cout << "logic -> expression" << std::endl;  
        $$ = $1;
    }
|
	logic EQUAL logic
    {
        std::cout << "logic -> logic EQUAL logic" << std::endl;  
        if(*$1 != *$3)
        {
            error("Tipushibas logika.\n");
        }  
        delete $1;
        delete $3;

        $$ = new type(boolean);
    }
|
	logic OR logic
    {
        std::cout << "logic -> logic OR logic" << std::endl;
        if(!(*$1 == *$3 && *$1 == boolean))
        {
            error("Tipushibas logika.\n");
        }  
        delete $1;
        delete $3;

        $$ = new type(boolean);
    }
|
	logic AND logic
    {
        std::cout << "logic -> logic AND logic" << std::endl;
        if(!(*$1 == *$3 && *$1 == boolean))
        {
            error("Tipushibas logika.\n");
        }  
        delete $1;
        delete $3;

        $$ = new type(boolean);
    }
|
	NOT logic
    {
        std::cout << "logic -> NOT logic" << std::endl;
        
        if(*$2 != boolean)
        {
            error("Tipushibas logika.\n");
        }  
        delete $2;

        $$ = new type(boolean);
    }
|
	logic SMALLER EQUAL logic
    {
        std::cout << "logic -> logic SMALLER EQUAL logic" << std::endl;
        if(!(*$1 == *$4 && *$1 == natural))
        {
            error("Tipushibas logika.\n");
        }  
        delete $1;
        delete $4;

        $$ = new type(boolean);
    }
|
	logic BIGGER EQUAL logic
    {
        std::cout << "logic -> logic BIGGER EQUAL logic" << std::endl;
        if(!(*$1 == *$4 && *$1 == natural))
        {
            error("Tipushibas logika.\n");
        }  
        delete $1;
        delete $4;

        $$ = new type(boolean);
    }
|
	logic SMALLER logic
    {
        std::cout << "logic -> logic SMALLER logic" << std::endl;
        if(!(*$1 == *$3 && *$1 == natural))
        {
            error("Tipushibas logika.\n");
        }  
        delete $1;
        delete $3;

        $$ = new type(boolean);
    }
|
	logic BIGGER logic
    {
        std::cout << "logic -> logic BIGGER logic" << std::endl;
        if(!(*$1 == *$3 && *$1 == natural))
        {
            error("Tipushibas logika.\n");
        }  
        delete $1;
        delete $3;

        $$ = new type(boolean);
    }
|
    OPEN logic CLOSE
    {
        std::cout << "logic -> OPEN logic CLOSE" << std::endl;
        delete $2;

        $$ = new type(boolean);
    }
;

expression:
    VAR
    {
        std::cout << "expression -> VAR" << std::endl;
        if( szimbolumtabla.count(*$1) == 0 )
        {
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$1 << ".\n" << std::endl;
            error( ss.str().c_str() );
        }

        $$ = new type(szimbolumtabla[*$1].var_type);

        delete $1;
    }
|
    NUM
    {
        std::cout << "expression -> NUM" << std::endl;
        $$ = new type(natural);
    }
|
    TRUE
    {
        std::cout << "expression -> TRUE" << std::endl;
        $$ = new type(boolean);
    }
|
    FALSE
    {
        std::cout << "expression -> FALSE" << std::endl;
        $$ = new type(boolean);
    }
;

arithmetic:
    SUBTRACT expression FROM VAR
    {
        std::cout << "arithmetic -> SUBTRACT expression FROM VAR" << std::endl;
        if( szimbolumtabla.count(*$4) == 0 )
        {
            
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$4 << ".\n" << std::endl;
            error( ss.str().c_str() );
        } 
        
        if(*$2 != szimbolumtabla[*$4].var_type)
        {
            error("Tipushibas ertekadas.\n");
        }  
        delete $2;
        delete $4; 
    }
|
    ADD expression TO VAR
    {
        std::cout << "arithmetic -> ADD expression TO VAR END sequence" << std::endl;
        if( szimbolumtabla.count(*$4) == 0 )
        {
            
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$4 << ".\n" << std::endl;
            error( ss.str().c_str() );
        } 
        
        if(*$2 != szimbolumtabla[*$4].var_type)
        {
            error("Tipushibas ertekadas.\n");
        }  
        delete $2;
        delete $4; 
    }
|
    MULTIPLY VAR BY expression
    {
        std::cout << "arithmetic -> MULTIPLY VAR BY expression" << std::endl;
        if( szimbolumtabla.count(*$2) == 0 )
        {
            
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$2 << ".\n" << std::endl;
            error( ss.str().c_str() );
        } 
        
        if(szimbolumtabla[*$2].var_type != *$4)
        {
            error("Tipushibas ertekadas.\n");
        }  
        delete $2;
        delete $4; 
    }
|
    DIVIDE VAR BY expression
    {
        std::cout << "arithmetic -> DIVIDE VAR BY expression" << std::endl;
        if( szimbolumtabla.count(*$2) == 0 )
        {
            
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$2 << ".\n" << std::endl;
            error( ss.str().c_str() );
        } 
        
        if(szimbolumtabla[*$2].var_type != *$4)
        {
            error("Tipushibas ertekadas.\n");
        }  
        delete $2;
        delete $4; 
    }
|
    MOD VAR BY expression TO VAR
    {
        std::cout << "arithmetic -> MOD VAR BY expression TO VAR" << std::endl;
        if( szimbolumtabla.count(*$2) == 0)
        {
            
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$2 << ".\n" << std::endl;
            error( ss.str().c_str() );
        } 

        if( szimbolumtabla.count(*$6) == 0)
        {
            
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$6 << ".\n" << std::endl;
            error( ss.str().c_str() );
        } 
        
        if(!(szimbolumtabla[*$2].var_type == *$4 && *$4 == szimbolumtabla[*$6].var_type))
        {
            error("Tipushibas ertekadas.\n");
        }  
        delete $2;
        delete $4; 
        delete $6; 
    }
;




