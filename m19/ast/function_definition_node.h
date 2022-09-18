// $Id: function_definition_node.h,v 1.7 2019/05/20 15:45:30 ist186507 Exp $ -*- c++ -*-
#ifndef __M19_FUNCTIONDEFINITIONNODE_H__
#define __M19_FUNCTIONDEFINITIONNODE_H__

#include <cdk/ast/sequence_node.h>
#include <cdk/ast/basic_node.h>
#include <cdk/ast/expression_node.h>
#include "ast/body_node.h"
#include <string>

namespace m19{
    
    //class describing function definition
    
    class function_definition_node: public cdk::basic_node {
        
        basic_type *_type;
        std::string _identifier;
        int _qualifier;     //identifica se public = 0  ou friend = 1 ou private = 2
        cdk::sequence_node *_arguments;
        cdk::expression_node *_literal;
        m19::body_node *_body;
        
    public:
        inline function_definition_node(int lineno, basic_type *type, std::string identifier, int qualifier, cdk::sequence_node *arguments, cdk::expression_node *literal, m19::body_node *body) : cdk::basic_node(lineno), _type(type), _identifier(identifier), _qualifier(qualifier), _arguments(arguments), _literal(literal), _body(body) {
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
        inline cdk::sequence_node *arguments() {
            return _arguments;
        }
        inline cdk::expression_node *literal() {
            return _literal;
        }
        inline m19::body_node *body() {
            return _body;
        }
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_function_definition_node(this, level);
        }
        
    };
}

#endif
