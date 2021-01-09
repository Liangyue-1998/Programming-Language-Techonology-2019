%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void yyerror();
void newVariable(char *size, char *name);
void newIntegerVariable(char *size, char *name);
void checkVariable(char *name);
void checkSize(char *iden1, char *iden2);
void decimalSize(char *iden, char *digit);
void numberSize(char *digit, char *iden);
void integerBack(char *iden, char *digit);
void integerFront(char *digit, char *iden);


extern FILE *yyin;
extern int yylineno;
int yylex();
int number = 0;

int newputSize1[100];
int newputSize2[100];
char newputName[100][100];

%}

%union{
char *name1;
char *name2;
char *name3;
char *name4;
}

%start program
%token START 
%token MAIN 
%token EQUALSTO 
%token EQUALSTOVALUE 
%token ADD 
%token TO 
%token PRINT 
%token INPUT 
%token ENDNOW 
%token TEXT 
%token TERMINATOR 
%token SEMICOLON 
%token EQUATION 
%token MOVE 

 
%token <name1> DONUMBERTYPE NUMBERTYPE  
%token <name2> VARIABLE
%token <name3> DOUBLE
%token <name4> INTEGER

%%
  program: start E main R end          {printf("Compile successfully.\n");}
  |  start main end                    {printf("Compile successfully.\n");}
  |  start E main end                  {printf("Compile successfully.\n");}
  ;

  start: START TERMINATOR              
  ;

  E: declaration
  |  declaration E         
  ;

  declaration: NUMBERTYPE VARIABLE TERMINATOR   { newIntegerVariable($1, $2); }
  |  DONUMBERTYPE VARIABLE TERMINATOR           { newVariable($1, $2); }
  ;

  main: MAIN TERMINATOR             
  ;

  R: statement
  |  statement R
  ;

  statement: assignments        
  |  inputs                        
  |  outputs                       
  ;

    
  assignments: VARIABLE EQUALSTO VARIABLE TERMINATOR   {checkSize($1, $3); checkVariable($1); checkVariable($3);} 
  |  VARIABLE EQUALSTO DOUBLE TERMINATOR               {decimalSize($1,$3); checkVariable($1);}
  |  VARIABLE EQUALSTOVALUE DOUBLE TERMINATOR          {decimalSize($1,$3); checkVariable($1);}         
  |  ADD DOUBLE TO VARIABLE TERMINATOR                 {numberSize($2,$4);checkVariable($4);}                       
  |  ADD VARIABLE TO VARIABLE TERMINATOR               {checkSize($2, $4);checkVariable($2); checkVariable($4);}
  |  MOVE VARIABLE TO VARIABLE TERMINATOR              {checkSize($2, $4);checkVariable($2); checkVariable($4);}
  |  MOVE DOUBLE TO VARIABLE TERMINATOR                {numberSize($2,$4);checkVariable($4);} 
  |  VARIABLE EQUALSTO INTEGER TERMINATOR              {integerBack($1,$3); checkVariable($1);}
  |  VARIABLE EQUALSTOVALUE INTEGER TERMINATOR         {integerBack($1,$3); checkVariable($1);}
  |  ADD INTEGER TO VARIABLE TERMINATOR                {integerFront($2,$4); checkVariable($4);}  
  |  MOVE INTEGER TO VARIABLE TERMINATOR               {integerFront($2,$4); checkVariable($4);}          
  ;


  identifier: VARIABLE                                 {checkVariable($1);} 
  ;
  

  inputs: INPUT Q     
  ;

  Q: identifier TERMINATOR
  |  identifier SEMICOLON Q 
  ;


  outputs: PRINT W   
  ;  
  
  W:  TEXT TERMINATOR
  |  identifier TERMINATOR
  |  identifier SEMICOLON W
  |  TEXT SEMICOLON W

  end: ENDNOW TERMINATOR    
  ;
  


%%
void newVariable(char *size, char *name){

  char m[] = " ";
  char* p = strtok(size,m);
  while(p){

    break;
  }
  int counter = 0; 
  int nchar = 0;
  int lenX = strlen(p);
  while(1){
    if(p[counter] == '-'){

      break;
    }
    else 
      nchar += 1;
    counter++;
  }
   //printf("It is a %d-digit with %d decimal places number\n ", nchar, lenX-nchar-1);
   strcpy(newputName[number], name);
   newputSize1[number] = nchar;
   newputSize2[number] = lenX-nchar-1;
   if(number>=1){

    for(int i =0; i<=number-1; i++){

      if (strcmp(newputName[number], newputName[i]) == 0)
        printf("Line %d error: Variable exits.\n",yylineno);
    }
   }
   number++;
  
}

void newIntegerVariable(char *size, char *name){

  int nchar = 0;
  char m[] = " ";
  char* p = strtok(size,m);
  while(p){

    break;
  }
 
  int lenX = strlen(p);
  //printf("It is a %d-digit\n", lenX);
  strcpy(newputName[number], name);
  newputSize1[number] = lenX;
  newputSize2[number] = 0;
  if(number>=1){

    for(int i =0; i<=number-1; i++){

      if (strcmp(newputName[number], newputName[i]) == 0)
        printf("Line %d error: Variable exits.\n",yylineno);
    }
   }
  number++;
  
}

void checkVariable(char *name){
  
  char variableName[50];
  strcpy(variableName, name);
  int exit = 0;
  for(int i =0; i<=number; i++){
    if(strcmp(variableName, newputName[i]) == 0){
      exit++;
    }
  }
  if(exit == 0){
    printf("Line %d error: Undeclared identifier.\n", yylineno);
  }
  
}


void checkSize(char *iden1, char *iden2){
 
  char idenName1[50];
  strcpy(idenName1, iden1);

  char idenName2[50];
  strcpy(idenName2, iden2); 
  
  int count1=0; int count2 = 0;
  for(int i1 =0; i1<= number; i1++){
    if(strcmp(idenName1, newputName[i1]) == 0){
      count1 = i1;
      break;
      }
  }

  for(int i2 =0; i2<= number; i2++){
    if(strcmp(idenName2, newputName[i2]) == 0){
      count2 = i2;
      break;
     }
  }
  
  if(newputSize1[count1]!=newputSize1[count2] || newputSize2[count1]!=newputSize2[count2])
    printf("Line %d error: The size of identifier is not matched.\n", yylineno);

} 

void decimalSize(char *iden, char *digit){
   
   int n = 0;
  for(int i =0; i<= number; i++){
    if(strcmp(iden, newputName[i]) == 0){
      n = i;
      break;
      }
  }
  int leftX = newputSize1[n];
  int rightX = newputSize2[n];

  char m[] = " ";
  char* p = strtok(digit,m);
  while(p){

    break;
  }
  int counter = 0;
  int decimal = 0; 
  int integer = 0;
  int len = strlen(p);
  while(1){
    if(p[counter] == '.'){
      decimal = len-integer-2;
      break;
    }
    else 
      integer += 1;
    counter++;
    if(counter==len)
      break;
  }
  if(integer!=leftX||decimal!=rightX)
    printf("Line %d error: The size is not matched\n", yylineno);
}

void numberSize(char *digit, char *iden){
 
   int n = 0;
  for(int i =0; i<= number; i++){
    if(strcmp(iden, newputName[i]) == 0){
      n = i;
      break;
      }
  }
  int leftX = newputSize1[n];
  int rightX = newputSize2[n];

  char m[] = " ";
  char* p = strtok(digit,m);
  while(p){

    break;
  }
  int counter = 0;
  int decimal = 0; 
  int integer = 0;
  int len = strlen(p);
  while(1){
    if(p[counter] == '.'){
      decimal = len-integer-1;
      break;
    }
    else 
      integer += 1;
    counter++;
    if(counter == len)
      break;
  }
  if(integer!=leftX||decimal!=rightX)
    printf("Line %d error: The size is not matched\n", yylineno);
}


void integerBack(char *iden, char *digit){

  int n = 0;
  for(int i =0; i<= number; i++){
    if(strcmp(iden, newputName[i]) == 0){
      n = i;
      break;
      }
  }
  int leftX = newputSize1[n];
  int rightX = newputSize2[n];

  char m[] = " ";
  char* p = strtok(digit,m);
  while(p){

    break;
  }

  int len = strlen(p);
  int integer = len-1;
  int decimal = 0;
  printf("%d %d\n",integer, decimal);
  if(integer!=leftX||decimal!=rightX)
    printf("Line %d error: The size is not matched\n", yylineno);
}

void integerFront(char *digit, char *iden){

  int n = 0;
  for(int i =0; i<= number; i++){
    if(strcmp(iden, newputName[i]) == 0){
      n = i;
      break;
      }
  }
  int leftX = newputSize1[n];
  int rightX = newputSize2[n];

  char m[] = " ";
  char* p = strtok(digit,m);
  while(p){

    break;
  }
  int len = strlen(p);
  int integer = len;
  int decimal = 0;
  printf("%d %d\n",integer,decimal);
  if(integer!=leftX||decimal!=rightX)
    printf("Line %d error: The size is not matched\n", yylineno);
}

int main()
{
    
    yyparse();
    return 0;
}

void yyerror(char *msg){
    fprintf(stderr, "Line %d: %s\n", yylineno, msg);
}



