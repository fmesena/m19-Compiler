// $Id: variable_declaration_node.h,v 1.4 2019/05/20 15:45:30 ist186507 Exp $ -*- c++ -*-
#ifndef __M19_VARIABLEDECLARATIONNODE_H__
#define __M19_VARIABLEDECLARATIONNODE_H__

#include <cdk/ast/sequence_node.h>
#include <cdk/ast/basic_node.h>
#include <cdk/ast/expression_node.h>
#include <string>

namespace m19{
    
    class variable_declaration_node: public cdk::basic_node {
        
        int _qualifier;     //identifica se public = 0  ou friend = 1 ou private = 2
        basic_type *_type;
        std::string _identifier;
        cdk::expression_node *_init;
       
    public:
        inline variable_declaration_node(int lineno, basic_type *type, std::string identifier, int qualifier, cdk::expression_node *init) : cdk::basic_node(lineno), _qualifier(qualifier), _type(type), _identifier(identifier), _init(init){
        }
        
    public:
        inline int qualifier() {
            return _qualifier;
        }
        inline basic_type *type() {
            return _type;
        }
        inline std::string identifier() {
            return _identifier;
        }
        inline cdk::expression_node *init() {
            return _init;
        }
        
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_variable_declaration_node(this, level);
        }
    };
}

#endif
