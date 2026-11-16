%{
#include <stdio.h>

int yylex();
void yyerror(const char *s);
extern FILE *yyin;
int parsingError = 0;
extern int lexicalError;
extern int yylineno;
%}

%token 
ROBOT TASK BEGIN_KW END NUM TEXT CONST WHEN THEN OTHERWISE REPEAT TIMES 
MOVE TURN SAY SCAN DO PLUS MINUS MULT DIV MOD ASSIGN 
EQ NE LE LT GE GT LPAREN RPAREN SEMI COMMA DOT ID NUM_LITERAL TEXT_LITERAL

%type <String> ID
%type <String> TEXT_LITERAL
%type <Float> NUM_LITERAL

%union{
    char *String;
    float Float;
}

%%

Program:
    ROBOT ID SEMI tasks main_block
tasks:
    tasks task_def
    | /* ε */
task_def:
    TASK ID BEGIN_KW statements END SEMI
main_block:
    BEGIN_KW statements END DOT
statements:
    statements statement
    | statement
statement:    
    simple_stmt SEMI
    | when_stmt
    | repeat_stmt
simple_stmt:
    decl
    | const_decl
    | assign_stmt
    | move_stmt
    | turn_stmt
    | say_stmt
    | scan_stmt
    | call_stmt
decl:
    type ID
type:
    NUM
    | TEXT
const_decl:
    CONST ID ASSIGN literal
literal:
    NUM_LITERAL
    | TEXT_LITERAL
assign_stmt:
    ID ASSIGN expression
move_stmt:
    MOVE expression
turn_stmt:
    TURN expression
say_stmt:
    SAY expression_list
scan_stmt:
    SCAN ID
call_stmt:
    DO ID
when_stmt: 
    WHEN expression THEN statements END
    | WHEN expression THEN statements OTHERWISE statements END
repeat_stmt:
    REPEAT exp TIMES statements END
expression:
    exp EQ exp
    | exp NE exp
    | exp LT exp
    | exp LE exp
    | exp GT exp
    | exp GE exp
    | exp
exp:
    exp PLUS term
    | exp MINUS term
    | term
term:
    term MULT factor
    | term DIV factor
    | term MOD factor
    | factor
factor:
    LPAREN exp RPAREN
    | NUM_LITERAL
    | TEXT_LITERAL
    | ID
expression_list:
    expression_list COMMA expression
    | expression

%%

int main(int argc, char *argv[]){
    
    yyin = fopen(argv[1], "r");
    if(yyin){
        yyparse();
        fclose(yyin);
    }
    if(parsingError)
        return -1;

    if(lexicalError)
        fprintf(stdout, "Parsing completed with errors.\n");
    else
        fprintf(stdout, "Parsing completed successfully: no errors.\n");

    return 0;

}

void yyerror(const char *s){
    fprintf(stdout, "Syntax error at line %d\n", yylineno);
    parsingError = 1;
}