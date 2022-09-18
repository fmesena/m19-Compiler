// $Id: continue_node.h,v 1.2 2019/03/20 19:49:38 ist186507 Exp $ -*- c++ -*-
#ifndef __M19_CONTINUENODE_H__
#define __M19_CONTINUENODE_H__

#include <cdk/ast/sequence_node.h>
#include <cdk/ast/basic_node.h>

namespace m19 {
    
    class continue_node: public cdk::basic_node {
        
    public:
        inline continue_node(int lineno) : 
            basic_node(lineno){
        }
    
    public:
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_continue_node(this, level);
        }
        
    };
}

#endif
