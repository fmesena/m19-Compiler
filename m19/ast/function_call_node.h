// $Id: function_call_node.h,v 1.3 2019/05/23 15:38:24 ist186507 Exp $ -*- c++ -*-
#ifndef __M19_FUNCTIONCALLNODE_H__
#define __M19_FUNCTIONCALLNODE_H__

#include <cdk/ast/sequence_node.h>
#include <cdk/ast/expression_node.h>
#include <string>

namespace m19{
    
    class function_call_node: public cdk::expression_node {
        
        std::string _identifier;
        cdk::sequence_node *_arguments;
        
    public:
        inline function_call_node(int lineno, std::string identifier, cdk::sequence_node *arguments) : cdk::expression_node(lineno), _identifier(identifier), _arguments(arguments) {
            
        }
        
    public:
        inline std::string identifier() {
            return _identifier;
        }
        inline std::string identifier(std::string id) {
            return _identifier = id;
        }
        inline cdk::sequence_node *arguments() {
            return _arguments;
        }
        
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_function_call_node(this, level);
        }
    };
}

#endif
