// $Id: function_declaration_node.h,v 1.5 2019/04/10 16:57:58 ist186439 Exp $ -*- c++ -*-
#ifndef __M19_FUNCTIONDECLARATIONNODE_H__
#define __M19_FUNCTIONDECLARATIONNODE_H__

#include <cdk/ast/sequence_node.h>
#include <cdk/ast/basic_node.h>
#include <cdk/ast/expression_node.h>
#include <string>

namespace m19{
    
    class function_declaration_node: public cdk::basic_node {
        
        basic_type *_type;
        std::string _identifier;
        int _qualifier;     //identifica se private public ou friend
        cdk::sequence_node *_arguments;
       
    public:
        inline function_declaration_node(int lineno, basic_type *type, std::string identifier, int qualifier, cdk::sequence_node *arguments) : cdk::basic_node(lineno), _type(type), _identifier(identifier), _qualifier(qualifier), _arguments(arguments) {
            
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
        
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_function_declaration_node(this, level);
        }
    };
}

#endif
