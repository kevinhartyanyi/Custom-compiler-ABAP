%baseclass-preinclude "semantics.h"
%lsp-needed

%union
{
    std::string* szoveg;
    instr_data* instr_d;
    expr_data* expr_d;
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
%token <szoveg> NUM
%token TRUE FALSE
%token SEPARATOR
%token END


%token ADD SUBTRACT PLUS MINUS
%token MULTIPLY DIVIDE MOD


%type <szoveg> declaration
%type <expr_d> expression
%type <expr_d> logic
%type <instr_d> vardeclaration
%type <szoveg> body
%type <szoveg> statement
%type <szoveg> sequence
%type <szoveg> arithmetic

%left OR
%left AND
%right NOT

%left EQUAL
%left SMALLER BIGGER

%%

start:
    PROGRAM VAR END declaration
    {
        std::cout << ";start -> PROGRAM VAR END declaration" << std::endl;
        std::cout << ";Változó deklaráció: " << *$2 << std::endl;
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

        std::cout << std::string("") +
        "extern ki_elojeles_egesz\n" +
        "extern be_elojeles_egesz\n" +
        "extern ki_logikai\n" +
        "global main\n" +
        *$4;
    }
;

declaration:
    body
    {
        std::cout << ";declaration -> body" << std::endl;
        std::stringstream ss;
        ss << std::string("") +
        "section .text\n" +
        "main:\n" +
        *$1 +
        "ret\n";
        $$ = new std::string(ss.str());
        delete $1;
    }
|
    DATA DDOT vardeclaration body
    {
        std::cout << ";declaration -> DATA DDOT vardeclaration body" << std::endl;
        std::stringstream ss;
        ss << std::string("") +
        "section .bss\n" +
        $3->code +
        "section .text\n" +
        "main:\n" +
        *$4 +
        "ret\n";
        $$ = new std::string(ss.str());
        delete $3;
        delete $4;
    }
;

vardeclaration:
    VAR TYPE INT SEPARATOR vardeclaration
    {
        std::cout << ";vardeclaration -> VAR TYPE INT SEPARATOR vardeclaration" << std::endl;
        std::cout << ";Változó deklaráció: " << *$1 << std::endl;
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
        instr_data* data = new instr_data(
            d_loc__.first_line,
            *$1 +
            ": resb 4\n" +
            $5->code
        );
		$$ = data;
        delete $1;
        delete $5;
    }
|
    VAR TYPE BOOL SEPARATOR vardeclaration
    {
        std::cout << ";vardeclaration -> VAR TYPE BOOL SEPARATOR vardeclaration" << std::endl;
        std::cout << ";Változó deklaráció: " << *$1 << std::endl;
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
        instr_data* data = new instr_data(
            d_loc__.first_line,
            *$1 +
            ": resb 1\n" +
            $5->code
        );
		$$ = data;
        delete $1;
        delete $5;
    }
|
    VAR TYPE INT END
    {
        std::cout << ";vardeclaration -> VAR TYPE INT END" << std::endl;
        std::cout << ";Változó deklaráció: " << *$1 << std::endl;
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

        instr_data* data = new instr_data(
            d_loc__.first_line,
            *$1 +
            ": resb 4\n"
        );
		$$ = data;
        delete $1;
    }
|
    VAR TYPE BOOL END
    {
        std::cout << ";vardeclaration -> VAR TYPE BOOL END" << std::endl;
        std::cout << ";Változó deklaráció: " << *$1 << std::endl;
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

        instr_data* data = new instr_data(
            d_loc__.first_line,
            *$1 +
            ": resb 1\n"
        );
		$$ = data;
        delete $1;
    }
;

body:
    //empty
    {
        std::cout << ";body -> empty" << std::endl;
        $$ = new std::string("");
    }
|
    sequence
    {
        std::cout << ";body -> sequence" << std::endl;
        $$ = new std::string(*$1);
    }
;

sequence:
    statement sequence
    {
        std::cout << ";sequence -> statement sequence" << std::endl;
        $$ = new std::string(
            *$1 +
            *$2
        );
    }
|
    statement
    {
        std::cout << ";sequence -> statement" << std::endl;
        $$ = $1;
    }
;

statement:
    MOVE expression TO VAR END
    {
        std::cout << ";sequence -> MOVE expression TO VAR END" << std::endl;
        if( szimbolumtabla.count(*$4) == 0 )
        {
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$4 << ".\n" << std::endl;
            error( ss.str().c_str() );
        }

        if($2->var_type != szimbolumtabla[*$4].var_type)
        {
            error("Tipushibas ertekadas.\n");
        }

        $$ = new std::string(std::string("") +
            $2->code +
            "mov [" + *$4 + "], eax\n");

        delete $4;
        delete $2;
    }
|
    arithmetic END
    {
        std::cout << ";sequence -> arithmetic END" << std::endl;
        $$ = $1;
    }
|
    WRITE expression END
    {
        std::cout << ";sequence -> WRITE expression END" << std::endl;
        $$ = new std::string(std::string("") +
            $2->code +
            "push eax\n" + 
            "call ki_elojeles_egesz\n" +
            "add esp, 4\n"
        );
    }    
|
    WHILE logic END sequence ENDWHILE END
    {
        std::cout << ";sequence -> WHILE logic END sequence ENDWHILE" << std::endl;
        if($2->var_type != boolean)
        {
            error("Tipushibas IF.\n");
        }  
        std::string label = std::string("cikluseleje") + std::to_string(d_loc__.first_line);
        std::string labelend = std::string("ciklusvege") + std::to_string(d_loc__.first_line);

        $$ = new std::string(std::string("") +
            label + ":\n" +
            $2->code +
            "cmp al, 1\n" + 
            "jne near " + labelend + "\n" +
            *$4 +
            "jmp " + label + "\n" +
            labelend + ":\n"
        );
        delete $2;
    }
|
    READ TO VAR END
    {
        std::cout << ";sequence -> READ TO VAR END" << std::endl;
        if( szimbolumtabla.count(*$3) == 0 )
        {
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$3 << ".\n" << std::endl;
            error( ss.str().c_str() );
        }
        $$ = new std::string(std::string("") +
            "call be_elojeles_egesz\n" +
            "mov [" + *$3 + "], eax\n"
        );
    }
|
    IF logic END sequence ENDIF END
    {
        std::cout << ";sequence -> IF logic END sequence ENDIF END" << std::endl;
        if($2->var_type != boolean)
        {
            error("Tipushibas IF.\n");
        }  
        std::string label = std::string("labelegyagu") + std::to_string(d_loc__.first_line);
        $$ = new std::string(std::string("") +
            $2->code +
            "cmp al, 1\n" +
            "jne near " + label + "\n" +
            *$4 +
            label + ":\n"
        );
        delete $2;
    }
|
    IF logic END sequence ELSE END sequence ENDIF END
    {
        std::cout << ";sequence -> IF logic END sequence ELSE END sequence ENDIF END" << std::endl;
        if($2->var_type != boolean)
        {
            error("Tipushibas IF.\n");
        }  
        std::string label = std::string("labelketto") + std::to_string(d_loc__.first_line);
        std::string labelend = std::string("labelkettoend") + std::to_string(d_loc__.first_line);
        $$ = new std::string(std::string("") +
            $2->code +
            "cmp al, 1\n" +
            "jne near " + label + "\n" +
            *$4 +
            "jmp " + labelend + "\n" +
            label + ":\n" +
            *$7 +
            labelend + ":\n"
        );
        delete $2;
    }    
;


logic:
	expression
    {
        std::cout << ";logic -> expression" << std::endl;  
        //$$ = &$1->var_type;
        $$ = new expr_data($1->row,
            $1->var_type,
            std::string("") + 
            $1->code
            );
    }
|
	logic EQUAL logic
    {
        std::cout << ";logic -> logic EQUAL logic" << std::endl;  
        if($1->var_type != $3->var_type)
        {
            error("Tipushibas logika.\n");
        }  
        std::string label = std::string("labelegyenlo") + std::to_string(d_loc__.first_line);
        std::string labelend = std::string("labelegyenloend") + std::to_string(d_loc__.first_line);
        $$ = new expr_data(d_loc__.first_line,
            boolean,
            std::string("") + 
            $3->code + 
            "push eax\n" +
            $1->code +
            "pop ebx\n" +
            "cmp eax, ebx\n" +
            "je " + label + "\n" +
            "mov al, 0\n" +
            "jmp " + labelend + "\n" +
            label + ":\n" +
            "mov al, 1\n" +
            labelend + ":\n"
            );
        delete $1;
        delete $3;
    }
|
	logic OR logic
    {
        std::cout << ";logic -> logic OR logic" << std::endl;
        if(!($1->var_type == $3->var_type && $1->var_type == boolean))
        {
            error("Tipushibas logika.\n");
        }  
        $$ = new expr_data(d_loc__.first_line,
            boolean,
            std::string("") + 
            $3->code + 
            "push ax\n" +
            $1->code +
            "pop bx\n" +
            "or al, bl\n"
            );
        delete $1;
        delete $3;
    }
|
	logic AND logic
    {
        std::cout << ";logic -> logic AND logic" << std::endl;
        if(!($1->var_type == $3->var_type && $1->var_type == boolean))
        {
            error("Tipushibas logika.\n");
        }  
        $$ = new expr_data(d_loc__.first_line,
            boolean,
            std::string("") + 
            $3->code + 
            "push ax\n" +
            $1->code +
            "pop bx\n" +
            "and al, bl\n"
            );
        delete $1;
        delete $3;
    }
|
	NOT logic
    {
        std::cout << ";logic -> NOT logic" << std::endl;
        
        if($2->var_type != boolean)
        {
            error("Tipushibas logika.\n");
        }  

        std::string label = std::string("labelnot") + std::to_string(d_loc__.first_line);
        std::string labelend = std::string("labelnotend") + std::to_string(d_loc__.first_line);
        $$ = new expr_data(d_loc__.first_line,
            boolean,
            std::string("") + 
            $2->code + 
            "not eax\n"
            );
        
        delete $2;
    }
|
	logic SMALLER EQUAL logic
    {
        std::cout << ";logic -> logic SMALLER EQUAL logic" << std::endl;
        if(!($1->var_type == $4->var_type && $1->var_type == natural))
        {
            error("Tipushibas logika.\n");
        }  
        std::string label = std::string("labelsmallerequal") + std::to_string(d_loc__.first_line);
        std::string labelend = std::string("labelsmallerequalend") + std::to_string(d_loc__.first_line);
        $$ = new expr_data(d_loc__.first_line,
            boolean,
            std::string("") + 
            $4->code + 
            "push eax\n" +
            $1->code +
            "pop ebx\n" +
            "cmp eax, ebx\n" +
            "jbe " + label + "\n" +
            "mov al, 0\n" +
            "jmp " + labelend + "\n" +
            label + ":\n" +
            "mov al, 1\n" +
            labelend + ":\n"
            );
        delete $1;
        delete $4;
    }
|
	logic BIGGER EQUAL logic
    {
        std::cout << ";logic -> logic BIGGER EQUAL logic" << std::endl;
        if(!($1->var_type == $4->var_type && $1->var_type == natural))
        {
            error("Tipushibas logika.\n");
        }  
        std::string label = std::string("labelbiggerequal") + std::to_string(d_loc__.first_line);
        std::string labelend = std::string("labelbiggerequalend") + std::to_string(d_loc__.first_line);
        $$ = new expr_data(d_loc__.first_line,
            boolean,
            std::string("") + 
            $4->code + 
            "push eax\n" +
            $1->code +
            "pop ebx\n" +
            "cmp eax, ebx\n" +
            "jae " + label + "\n" +
            "mov al, 0\n" +
            "jmp " + labelend + "\n" +
            label + ":\n" +
            "mov al, 1\n" +
            labelend + ":\n"
            );
        delete $1;
        delete $4;
    }
|
	logic SMALLER logic
    {
        std::cout << ";logic -> logic SMALLER logic" << std::endl;
        if(!($1->var_type == $3->var_type && $1->var_type == natural))
        {
            error("Tipushibas logika.\n");
        }  
        std::string label = std::string("labelsmaller") + std::to_string(d_loc__.first_line);
        std::string labelend = std::string("labelsmallerend") + std::to_string(d_loc__.first_line);
        $$ = new expr_data(d_loc__.first_line,
            boolean,
            std::string("") + 
            $3->code + 
            "push eax\n" +
            $1->code +
            "pop ebx\n" +
            "cmp eax, ebx\n" +
            "jb " + label + "\n" +
            "mov al, 0\n" +
            "jmp " + labelend + "\n" +
            label + ":\n" +
            "mov al, 1\n" +
            labelend + ":\n"
            );
        delete $1;
        delete $3;
    }
|
	logic BIGGER logic
    {
        std::cout << ";logic -> logic BIGGER logic" << std::endl;
        if(!($1->var_type == $3->var_type && $1->var_type == natural))
        {
            error("Tipushibas logika.\n");
        }  
        std::string label = std::string("labelbigger") + std::to_string(d_loc__.first_line);
        std::string labelend = std::string("labelbiggerend") + std::to_string(d_loc__.first_line);
        $$ = new expr_data(d_loc__.first_line,
            boolean,
            std::string("") + 
            $3->code + 
            "push eax\n" +
            $1->code +
            "pop ebx\n" +
            "cmp eax, ebx\n" +
            "ja " + label + "\n" +
            "mov al, 0\n" +
            "jmp " + labelend + "\n" +
            label + ":\n" +
            "mov al, 1\n" +
            labelend + ":\n"
            );
        delete $1;
        delete $3;
    }
|
    OPEN logic CLOSE
    {
        std::cout << ";logic -> OPEN logic CLOSE" << std::endl;
        delete $2;

        $$ = new expr_data(d_loc__.first_line,
            $2->var_type,
            std::string("") + 
            $2->code
            );
    }
;

expression:
    VAR
    {
        std::cout << ";expression -> VAR" << std::endl;
        if( szimbolumtabla.count(*$1) == 0 )
        {
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$1 << ".\n" << std::endl;
            error( ss.str().c_str() );
        }

        $$ = new expr_data(d_loc__.first_line,
            szimbolumtabla[*$1].var_type,
            std::string("") + 
            "mov eax, [" + *$1 + "]\n"
            );

        delete $1;
    }
|
    NUM
    {
        std::cout << ";expression -> NUM" << std::endl;
        //$$ = new type(natural);
        $$ = new expr_data(d_loc__.first_line,
            natural,
            std::string("") + 
            "mov eax, " + *$1 + "\n"
            );
    }
|
    TRUE
    {
        std::cout << ";expression -> TRUE" << std::endl;
        //$$ = new type(boolean);
        $$ = new expr_data(d_loc__.first_line,
            boolean,
            std::string("") + 
            "mov eax, 1\n"
            );
    }
|
    FALSE
    {
        std::cout << ";expression -> FALSE" << std::endl;
        //$$ = new type(boolean);
        $$ = new expr_data(d_loc__.first_line,
            boolean,
            std::string("") + 
            "mov eax, 0\n"
            );
    }
;

arithmetic:
    SUBTRACT expression FROM VAR
    {
        std::cout << ";arithmetic -> SUBTRACT expression FROM VAR" << std::endl;
        if( szimbolumtabla.count(*$4) == 0 )
        {
            
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$4 << ".\n" << std::endl;
            error( ss.str().c_str() );
        } 
        
        if($2->var_type != szimbolumtabla[*$4].var_type)
        {
            error("Tipushibas ertekadas.\n");
        }  
        $$ = new std::string(std::string("") + 
            $2->code +
            "push eax\n" + 
            "mov eax, [" + *$4 + "]\n" + 
            "pop ebx\n" +
            "sub eax, ebx\n" +
            "mov [" + *$4 + "], eax\n" 
        );
        delete $2;
        delete $4; 
    }
|
    ADD expression TO VAR
    {
        std::cout << ";arithmetic -> ADD expression TO VAR END sequence" << std::endl;
        if( szimbolumtabla.count(*$4) == 0 )
        {
            
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$4 << ".\n" << std::endl;
            error( ss.str().c_str() );
        } 
        
        if($2->var_type != szimbolumtabla[*$4].var_type)
        {
            error("Tipushibas ertekadas.\n");
        }  

        $$ = new std::string(std::string("") + 
            $2->code +
            "push eax\n" + 
            "mov eax, [" + *$4 + "]\n" + 
            "pop ebx\n" +
            "add eax, ebx\n" +
            "mov [" + *$4 + "], eax\n" 
        );

        delete $2;
        delete $4; 
    }
|
    MULTIPLY VAR BY expression
    {
        std::cout << ";arithmetic -> MULTIPLY VAR BY expression" << std::endl;
        if( szimbolumtabla.count(*$2) == 0 )
        {
            
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$2 << ".\n" << std::endl;
            error( ss.str().c_str() );
        } 
        
        if(szimbolumtabla[*$2].var_type != $4->var_type)
        {
            error("Tipushibas ertekadas.\n");
        }  
        $$ = new std::string(std::string("") + 
            $4->code +
            "mul dword [" + *$2 + "]\n" + 
            "mov [" + *$2 + "], eax\n" 
        );
        delete $2;
        delete $4; 
    }
|
    DIVIDE VAR BY expression
    {
        std::cout << ";arithmetic -> DIVIDE VAR BY expression" << std::endl;
        if( szimbolumtabla.count(*$2) == 0 )
        {
            
            std::stringstream ss;
            ss << "Nem deklaralt valtozo: " << *$2 << ".\n" << std::endl;
            error( ss.str().c_str() );
        } 
        
        if(szimbolumtabla[*$2].var_type != $4->var_type)
        {
            error("Tipushibas ertekadas.\n");
        }  
        $$ = new std::string(std::string("") + 
            $4->code +
            "push eax\n" + 
            "mov eax, [" + *$2 + "]\n" + 
            "pop ebx\n" +
            "sub eax, ebx\n" +
            "mov [" + *$2 + "], eax\n" 
        );
        delete $2;
        delete $4; 
    }
|
    MOD VAR BY expression TO VAR
    {
        std::cout << ";arithmetic -> MOD VAR BY expression TO VAR" << std::endl;
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
        
        if(!(szimbolumtabla[*$2].var_type == $4->var_type && $4->var_type == szimbolumtabla[*$6].var_type))
        {
            error("Tipushibas ertekadas.\n");
        }  
        $$ = new std::string(std::string("") + 
            $4->code +
            "mov edx, 0\n" +
            "mov ebx, [" + *$2 + "]\n" + 
            "div ebx\n" +
            "mov [" + *$6 + "], eax\n"
        );
        delete $2;
        delete $4; 
        delete $6; 
    }
;




