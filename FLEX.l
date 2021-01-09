%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

%}

%option yylineno
%option caseless

%%

[\t ]+    /* ignore white space */ ;

"START"             {return START;}
"MAIN"              {return MAIN;}
"EQUALS-TO"         {return EQUALSTO;}
"EQUALS-TO-VALUE"   {return EQUALSTOVALUE;} 
"ADD"               {return ADD;} 
"TO"                {return TO;}
"MOVE"              {return MOVE;} 

\.                  {return TERMINATOR;}  
\;                  {return SEMICOLON;}  
\=                  {return EQUATION;}
       

"PRINT"             {return PRINT;} 
"INPUT"             {return INPUT;}
"END-NOW"           {return ENDNOW;}

[X]+                {yylval.name1 = yytext; return NUMBERTYPE;}
[X]+\-[X]+          {yylval.name1 = yytext; return DONUMBERTYPE;}
[a-zA-Z]{1}[a-zA-Z0-9-]{0,7}      {yylval.name2 = malloc(sizeof(char*) * strlen(yytext)); strcpy(yylval.name2, yytext);  return VARIABLE;}
[0-9]+              {yylval.name4 = yytext; return INTEGER;}
[0-9]+\.[0-9]{1,7}                {yylval.name3 = yytext; return DOUBLE;}
\"[^\"]*["]         {return TEXT;}  

%%

int yywrap(){
  return 1;
}



