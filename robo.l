%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "robo.tab.h"
void yyerror(const char *s);
int lexicalError = 0;
%}

%option noyywrap
%option yylineno

id [a-z][a-zA-Z0-9_]*
num [0-9]+(\.[0-9]+)?
text '[^'\n]*'
whitespace [ \t\r\n]+


%%

"robot"        { return ROBOT; }
"task"         { return TASK; }
"begin"        { return BEGIN_KW; }
"end"          { return END; }
"num"          { return NUM; }
"text"         { return TEXT; }
"const"        { return CONST; }
"when"         { return WHEN; }
"then"         { return THEN; }
"otherwise"    { return OTHERWISE; }
"repeat"       { return REPEAT; }
"times"        { return TIMES; }
"move"         { return MOVE; }
"turn"         { return TURN; }
"say"          { return SAY; }
"scan"         { return SCAN; }
"do"           { return DO; }

"+"            { return PLUS; }
"-"            { return MINUS; }
"*"            { return MULT; }
"/"            { return DIV; }
"%"            { return MOD; }
":="           { return ASSIGN; }
"="            { return EQ; }
"!="           { return NE; }
"<="           { return LE; }
"<"            { return LT; }
">="           { return GE; }
">"            { return GT; }
"("            { return LPAREN; }
")"            { return RPAREN; }
";"            { return SEMI; }
","            { return COMMA; }
"."            { return DOT; }

{id}           { 
                    yylval.String = malloc((yyleng + 1) * sizeof(char));
                    strcpy(yylval.String, yytext);
                    return ID; 
               }
{num}          { yylval.Float = atof(yytext); return NUM_LITERAL; }
{text}         { 
                    yylval.String = malloc((yyleng + 1) * sizeof(char));
                    strcpy(yylval.String, yytext);
                    return TEXT_LITERAL; 
               }
"{"[^}]*"}"    { }
{whitespace}   { }
.              { 
                    printf("Lexical error at line %d: invalid character '%s'\n", yylineno, yytext);
                    lexicalError = 1;
               }

%%