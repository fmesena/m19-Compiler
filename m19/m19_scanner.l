%option c++ prefix="m19_scanner_" outfile="m19_scanner.cpp"
%option stack noyywrap yylineno 8bit debug

%{ 
// make relevant includes before including the parser's tab file
#include <string>
#include <algorithm>
#include <cdk/ast/sequence_node.h>
#include <cdk/ast/expression_node.h>
#include <cdk/ast/lvalue_node.h>
#include "m19_parser.tab.h"

// don't change this
#define yyerror LexerError

#include <sstream>
#include <math.h>
static std::ostringstream strlit;
%}
%x X_STRING X_BARRA X_BZERO
%x X_COMMENT

%%
    //{set_debug(1);}

 /*-----------------------------------------------------------------------------------------*/
 /*----------------------------------Comentarios--------------------------------------------*/
 
"//"                ;

"/*"                yy_push_state(X_COMMENT);
<X_COMMENT>"/*"     yy_push_state(X_COMMENT);
<X_COMMENT>"*/"     yy_pop_state();
<X_COMMENT>.|\n     ;
 
 /*-----------------------------------------------------------------------------------------*/
 /*----------------------------------CadeiaDeCaracteres-------------------------------------*/
 
\"                          yy_push_state(X_STRING);
<X_STRING>\\                yy_push_state(X_BARRA);
<X_STRING>\"                {
                                yylval.s = new std::string(strlit.str());
                                strlit.str("");
                                yy_pop_state();
                                return tSTRING;
                            }
<X_STRING>.                 strlit << *yytext;

<X_BARRA>n                  strlit << '\n'; yy_pop_state();
<X_BARRA>r                  strlit << '\r'; yy_pop_state();
<X_BARRA>t                  strlit << '\t'; yy_pop_state();
<X_BARRA>\\\"               yy_pop_state();
<X_BARRA>\"                 yy_pop_state();
<X_BARRA>\\                 strlit << '\\'; yy_pop_state();
<X_BARRA>[A-Fa-f0-9]{1,2}   {
                                strlit << (char)(unsigned char)strtoul(yytext, NULL, 16);
                                if(errno == ERANGE) yyerror("Invalid number: overflow");
                                yy_pop_state();
                            }
<X_BARRA>.                  strlit << *yytext; yy_pop_state();

 /*-----------------------------------------------------------------------------------------*/
 /*----------------------------------Inteiros-----------------------------------------------*/
 /*hexadecimais*/
0x[A-Fa-f0-9]+          yylval.i = strtol(yytext, nullptr, 16); if(errno == ERANGE) yyerror("Invalid number: overflow"); return tINTEGER;

0x[A-Za-z0-9]+          yyerror("Invalid base 16 number");

 /*decimais*/
[0-9]+                  yylval.i = strtol(yytext, nullptr, 10); if(errno == ERANGE) yyerror("Invalid number: overflow"); return tINTEGER;                

 /*-----------------------------------------------------------------------------------------*/
 /*-----------------------------------Reais em Virgula Flutuante----------------------------*/

[0-9]+\.[0-9]+      yylval.d = strtod(yytext, nullptr); if(errno == ERANGE) yyerror("Invalid number: overflow"); return tREAL; 

[0-9]+a[0-9]+     { std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'a') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, -18);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;
                  }
[0-9]+f[0-9]+     { std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'f') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, -15);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;
                  }
[0-9]+p[0-9]+     { std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'p') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, -12);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;
                  }
[0-9]+n[0-9]+     { std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'n') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, -9);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;
                  }
[0-9]+u[0-9]+     { std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'u') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, -6);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;
                  }
[0-9]+m[0-9]+     { std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'm') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, -3);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;
                  }
[0-9]+k[0-9]+     {
                    std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'k') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, 3);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;/*yylval.d = strtod( (std::string (yytext).replace(1, yyleng, 'k', '.')).c_str(), nullptr)*pow(10, 3); std::cout << "yytext " << yytext << std::endl; std::cout << "yylval " << yylval.d << std::endl; if(errno == ERANGE) yyerror("Invalid number: overflow"); return tREAL;*/}
[0-9]+M[0-9]+     { std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'M') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, 6);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;
                  }
[0-9]+G[0-9]+     { std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'G') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, 9);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;
                  }
[0-9]+T[0-9]+     { std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'T') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, 12);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;
                  }
[0-9]+P[0-9]+     { std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'P') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, 15);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;
                  }
[0-9]+E[0-9]+     { std::string s = std::string (yytext);
                    for (int i = 0; i < yyleng; ++i){
                        if(s[i] == 'E') s[i] = '.';
                    }
                    yylval.d = strtod(s.c_str(), nullptr)*pow(10, 18);
                    if(errno == ERANGE) yyerror("Invalid number: overflow");
                    return tREAL;
                  }
 /*-----------------------------------------------------------------------------------------*/
 /*------------------------------------Identificadores--------------------------------------*/
 
[A-Za-z][A-Za-z0-9_]*  yylval.s = new std::string(yytext); return tID;

 /*-----------------------------------------------------------------------------------------*/
 /*------------------------------------Delimitadores/Terminadores---------------------------*/
 
 /*-----------------------------------------------------------------------------------------*/
 /*------------------------------------Expressoes-------------------------------------------*/ 
 
">="                   return tGE; 
"<="                   return tLE; 
"=="                   return tEQ; 
"!="                   return tNE;

"~"                    return tNOT;
"&&"                   return tAND;
"||"                   return tOR;
 
"!!"                   return tPRINTLN;

">>@"                  return tBREAK;
"@>>"                  return tCONTINUE;
">@<"                  return tRETURN;

">>"                   return tGG;
"<<"                   return tLL;

 /*-----------------------------------------------------------------------------------------*/
 
[-()<>=+*/%;{}.!#?$\[\]:,@]      return *yytext;

[ \t\n]+               ; /* ignore whitespace */

.                      yyerror("Unknown character");

%%
