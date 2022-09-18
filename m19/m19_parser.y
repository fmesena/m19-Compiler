%{
//-- don't change *any* of these: if you do, you'll break the compiler.
#include <cdk/compiler.h>
#include "ast/all.h"
#define LINE               compiler->scanner()->lineno()
#define yylex()            compiler->scanner()->scan()
#define yyerror(s)         compiler->scanner()->error(s)
#define YYPARSE_PARAM_TYPE std::shared_ptr<cdk::compiler>
#define YYPARSE_PARAM      compiler
//-- don't change *any* of these --- END!

%}

%union {
  int                   i;          /* integer value */
  double                d;
  std::string          *s;          /* symbol name */
  cdk::basic_node      *node;       /* node pointer */
  cdk::sequence_node   *sequence;
  cdk::expression_node *expression; /* expression nodes */
  cdk::lvalue_node     *lvalue;
  basic_type           *btype;
  m19::block_node *block;
  m19::body_node *body;
};

%token <i> tINTEGER
%token <s> tID tSTRING
%token <d> tREAL
%token tPRINTLN tPRINT tBREAK tCONTINUE tRETURN tGG tLL tOR tAND        tFROM tTO tAPPLY

%type <node> program decl func_def func_decl var sec instr var_func var_block
%type <sequence>  decls secs instrs exprs decls_block exprs_vars argumentos var_for
%type <expression> expr literal
%type <lvalue> lval
%type <btype> tipo
%type <block> block
%type <body> body
%type <i> qualifier
%type <s> string

%nonassoc tIF
%nonassoc ':'

%right '='
%left tOR
%left tAND
%right tNOT
%left tEQ tNE
%left tGE tLE '>' '<'
%left '+' '-'
%left '*' '/' '%'
%nonassoc tUNARY tADDR


%{
//-- The rules below will be included in yyparse, the main parsing function.
%}
%%

program	    : decls                 {compiler->ast(new cdk::sequence_node(LINE, $1));}
            ;
            
decl        : var';'                { $$ = $1;}
            | func_def              { $$ = $1;}
            | func_decl             { $$ = $1;}
            ;

decls       : decl                  { $$ = new cdk::sequence_node(LINE, $1);}
            | decls decl            { $$ = new cdk::sequence_node(LINE, $2, $1);}
            ;
            
func_def    : tipo tID qualifier '(' argumentos ')' '=' literal  body           { $$ = new m19::function_definition_node(LINE, $1, *$2, $3, $5, $8, $9); delete $2;}
            | tipo tID           '(' argumentos ')' '=' literal  body           { $$ = new m19::function_definition_node(LINE, $1, *$2,  2, $4, $7, $8); delete $2;}
            
            | '!'  tID qualifier '(' argumentos ')' '=' literal  body           { $$ = new m19::function_definition_node(LINE, new basic_type(0, basic_type::TYPE_VOID), *$2, $3, $5, $8, $9); delete $2;}
            | '!'  tID           '(' argumentos ')' '=' literal  body           { $$ = new m19::function_definition_node(LINE, new basic_type(0, basic_type::TYPE_VOID), *$2,  2, $4, $7, $8); delete $2;}
            
            
            | tipo tID qualifier '(' argumentos ')'              body           { $$ = new m19::function_definition_node(LINE, $1, *$2, $3, $5, nullptr, $7); delete $2;}
            | tipo tID           '(' argumentos ')'              body           { $$ = new m19::function_definition_node(LINE, $1, *$2,  2, $4, nullptr, $6); delete $2;}
            
            | '!'  tID qualifier '(' argumentos ')'              body           { $$ = new m19::function_definition_node(LINE, new basic_type(0, basic_type::TYPE_VOID), *$2, $3, $5, nullptr, $7); delete $2;}
            | '!'  tID           '(' argumentos ')'              body           { $$ = new m19::function_definition_node(LINE, new basic_type(0, basic_type::TYPE_VOID), *$2,  2, $4, nullptr, $6); delete $2;}

            ;

func_decl   : tipo tID qualifier '(' argumentos ')'                             { $$ = new m19::function_declaration_node(LINE, $1, *$2, $3, $5); delete $2;}
            | tipo tID           '(' argumentos ')'                             { $$ = new m19::function_declaration_node(LINE, $1, *$2,  2, $4); delete $2;}
            | '!'  tID qualifier '(' argumentos ')'                             { $$ = new m19::function_declaration_node(LINE, new basic_type(0, basic_type::TYPE_VOID), *$2, $3, $5); delete $2;}
            | '!'  tID           '(' argumentos ')'                             { $$ = new m19::function_declaration_node(LINE, new basic_type(0, basic_type::TYPE_VOID), *$2,  2, $4); delete $2;}
            ;
      
            
tipo        : '#'                    { $$ = new basic_type(4, basic_type::TYPE_INT);}
            | '%'                    { $$ = new basic_type(8, basic_type::TYPE_DOUBLE);}
            | '$'                    { $$ = new basic_type(4, basic_type::TYPE_STRING);}
            | '<' tipo '>'           { $$ = new basic_type(4, basic_type::TYPE_POINTER); $$->_subtype = $2;}
            ;
            
argumentos  : var_func                     { $$ = new cdk::sequence_node(LINE, $1);}
            | var_func ',' argumentos      { $$ = new cdk::sequence_node(LINE, $1, $3);}
            | /*empty*/                    { $$ = new cdk::sequence_node(LINE);}
            ;

var_for     : var_block                     { $$ = new cdk::sequence_node(LINE, $1);}
            | var_block ',' argumentos      { $$ = new cdk::sequence_node(LINE, $1, $3);}
            | /*empty*/                     { $$ = new cdk::sequence_node(LINE);}
            ;
    
var         : tipo tID qualifier '=' expr     { $$ = new m19::variable_declaration_node(LINE, $1, *$2, $3, $5); delete $2;}
            | tipo tID           '=' expr     { $$ = new m19::variable_declaration_node(LINE, $1, *$2,  2, $4); delete $2;}
            | tipo tID                        { $$ = new m19::variable_declaration_node(LINE, $1, *$2,  2, nullptr); delete $2;}
            ;
            
var_func    : tipo tID                        { $$ = new m19::variable_declaration_node(LINE, $1, *$2,  2, nullptr); delete $2;}
            ;
            
var_block   : tipo tID           '=' expr     { $$ = new m19::variable_declaration_node(LINE, $1, *$2,  2, $4); delete $2; }
            | tipo tID                        { $$ = new m19::variable_declaration_node(LINE, $1, *$2,  2, nullptr); delete $2;}
            ;
            
qualifier   : '!'           { $$ = 0; }
            | '?'           { $$ = 1; }
            ;

literal     : tINTEGER               { $$ = new cdk::integer_node(LINE, $1); }
            | string                 { $$ = new cdk::string_node(LINE, $1);}
            | tREAL                  { $$ = new cdk::double_node(LINE, $1);}
            ;

string      : tSTRING               { $$ = $1;}
            | string tSTRING        { $$ = new std::string(*$1 + *$2); delete $1; delete $2;}
            ;

block       : '{' decls_block instrs '}'  { $$ = new m19::block_node(LINE, $2, $3);}
            | '{' decls_block        '}'  { $$ = new m19::block_node(LINE, $2, nullptr);}
            | '{'             instrs '}'  { $$ = new m19::block_node(LINE, nullptr, $2);}
            | '{'                    '}'  { $$ = new m19::block_node(LINE, nullptr, nullptr);}
            ;
            
decls_block : var_block ';'                         { $$ = new cdk::sequence_node(LINE, $1);} 
            | var_block ';' decls_block             { $$ = new cdk::sequence_node(LINE, $1, $3);}
            ;

body        : tLL block secs tGG block        { $$ = new m19::body_node(LINE, new m19::initial_section_node(LINE, $2), $3, new m19::final_section_node(LINE, $5));}
            | tLL block secs                  { $$ = new m19::body_node(LINE, new m19::initial_section_node(LINE, $2), $3, nullptr);}
            |           secs tGG block        { $$ = new m19::body_node(LINE, nullptr, $1, new m19::final_section_node(LINE, $3));}
            | tLL block      tGG block        { $$ = new m19::body_node(LINE, new m19::initial_section_node(LINE, $2), nullptr, new m19::final_section_node(LINE, $4));}
            | tLL block                       { $$ = new m19::body_node(LINE, new m19::initial_section_node(LINE, $2), nullptr, nullptr);}
            |           secs                  { $$ = new m19::body_node(LINE, nullptr, $1, nullptr);}
            |                tGG block        { $$ = new m19::body_node(LINE, nullptr, nullptr, new m19::final_section_node(LINE, $2));}
            ;

secs        : sec                                { $$ = new cdk::sequence_node(LINE, $1);}
            | secs sec                           { $$ = new cdk::sequence_node(LINE, $2, $1);}
            ;

sec         : '[' expr ']' block               { $$ = new m19::section_node(LINE, $2, $4, 0);}
            | '['      ']' block               { $$ = new m19::section_node(LINE, nullptr, $3, 0);}
            | '(' expr ')' block               { $$ = new m19::section_node(LINE, $2, $4, 1);}
            | '('      ')' block               { $$ = new m19::section_node(LINE, nullptr, $3, 1);}
            |              block               { $$ = new m19::section_node(LINE, nullptr, $1, 2);}
            ;

exprs       : expr                              { $$ = new cdk::sequence_node(LINE, $1);}
            | exprs ',' expr                        { $$ = new cdk::sequence_node(LINE, $3, $1);}
            ;
                
instrs      : instr                             { $$ = new cdk::sequence_node(LINE, $1);}
            | instrs instr                      { $$ = new cdk::sequence_node(LINE, $2, $1);}
            ;
            
instr       : expr ';'                          { $$ = new m19::evaluation_node(LINE, $1); }
            | expr '!'                          { $$ = new m19::print_node(LINE, $1, false); }
            | expr tPRINTLN                     { $$ = new m19::print_node(LINE, $1, true); }
            | tBREAK                            { $$ = new m19::break_node(LINE); }
            | tCONTINUE                         { $$ = new m19::continue_node(LINE); }
            | tRETURN                           { $$ = new m19::return_node(LINE); }
            
            | '[' expr ']' '#' instr                        { $$ = new m19::if_node(LINE, $2, $5); }
            | '[' expr ']' '?' instr          %prec tIF     { $$ = new m19::if_node(LINE, $2, $5); }
            | '[' expr ']' '?' instr ':' instr              { $$ = new m19::if_else_node(LINE, $2, $5, $7); }
            
            | '[' exprs_vars ';' exprs ';' exprs ']' instr                { $$ = new m19::for_node(LINE, $2, $4, $6, $8); }
            | '[' exprs_vars ';' exprs ';'       ']' instr                { $$ = new m19::for_node(LINE, $2, $4, nullptr, $7); }
            | '[' exprs_vars ';'       ';' exprs ']' instr                { $$ = new m19::for_node(LINE, $2, nullptr, $5, $7); }         
            | '[' exprs_vars ';'       ';'       ']' instr                { $$ = new m19::for_node(LINE, $2, nullptr, nullptr, $6); }
            
            | block                                                       { $$ = $1; }
            ;
            
            
exprs_vars  : var_for     { $$ = $1;}
            | exprs          { $$ = $1;}
            ;
            
expr        : literal                   { $$ = $1; }
            | '+' expr %prec tUNARY     { $$ = new m19::identity_node(LINE, $2); }
            | '-' expr %prec tUNARY     { $$ = new cdk::neg_node(LINE, $2); }
            | expr '+' expr             { $$ = new cdk::add_node(LINE, $1, $3); }
            | expr '-' expr             { $$ = new cdk::sub_node(LINE, $1, $3); }
            | expr '*' expr             { $$ = new cdk::mul_node(LINE, $1, $3); }
            | expr '/' expr             { $$ = new cdk::div_node(LINE, $1, $3); }
            | expr '%' expr             { $$ = new cdk::mod_node(LINE, $1, $3); }
            | expr '<' expr             { $$ = new cdk::lt_node(LINE, $1, $3); }
            | expr '>' expr             { $$ = new cdk::gt_node(LINE, $1, $3); }
            | expr tGE expr             { $$ = new cdk::ge_node(LINE, $1, $3); }
            | expr tLE expr             { $$ = new cdk::le_node(LINE, $1, $3); }
            | expr tNE expr             { $$ = new cdk::ne_node(LINE, $1, $3); }
            | expr tEQ expr             { $$ = new cdk::eq_node(LINE, $1, $3); }
            | expr tOR expr             { $$ = new cdk::or_node(LINE, $1, $3);}
            | expr tAND expr            { $$ = new cdk::and_node(LINE, $1, $3);}
            | tNOT expr                 { $$ = new cdk::not_node(LINE, $2);}
            
            //| expr  '[' expr ']'                         { std::cout << "3" << std::endl; /*$$ = new m19::index_node(LINE, $2, $5);*/}

            | '(' expr ')'              { $$ = $2; }
            | lval                      { $$ = new cdk::rvalue_node(LINE, $1); }
            | lval '=' expr             { $$ = new cdk::assignment_node(LINE, $1, $3); }
            | '@' '=' expr              { $$ = new cdk::assignment_node(LINE, new cdk::variable_node(LINE, "@"), $3); }
            | lval '?' %prec tADDR      { $$ = new m19::address_node(LINE, $1);}
            | '[' expr ']'              { $$ = new m19::alloc_node(LINE, $2);}

            | tID '(' exprs ')'         { $$ = new m19::function_call_node(LINE, *$1, $3); delete $1;}
            | tID '('       ')'         { $$ = new m19::function_call_node(LINE, *$1, nullptr); delete $1;}
            | '@' '(' exprs ')'         { $$ = new m19::function_call_node(LINE, "@", $3);}
            | '@' '('       ')'         { $$ = new m19::function_call_node(LINE, "@", nullptr);}
            | '@'                       { $$ = new m19::read_node(LINE); }
            ;

lval        : tID                                               { $$ = new cdk::variable_node(LINE, *$1); delete $1; }
            | lval         '[' expr ']'                         { $$ = new m19::index_node(LINE, new cdk::rvalue_node(LINE, $1), $3);}
            | '( 'expr ')' '[' expr ']'                         { $$ = new m19::index_node(LINE, $2, $5); }
            | tID '(' exprs ')' '[' expr ']'                    { $$ = new m19::index_node(LINE, new m19::function_call_node(LINE, *$1, $3), $6); delete $1;}
            | tID '('       ')' '[' expr ']'                    { $$ = new m19::index_node(LINE, new m19::function_call_node(LINE, *$1, nullptr), $5); delete $1;}
            | '@' '(' exprs ')' '[' expr ']'                    { $$ = new m19::index_node(LINE, new m19::function_call_node(LINE, "@", $3), $6);}
            | '@' '('       ')' '[' expr ']'                    { $$ = new m19::index_node(LINE, new m19::function_call_node(LINE, "@", nullptr), $5);}
            | '@'               '[' expr ']'                    { $$ = new m19::index_node(LINE, new cdk::rvalue_node(LINE, new cdk::variable_node(LINE, "@")), $3);}
            ;


%%
