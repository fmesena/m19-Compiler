// $Id: return_node.h,v 1.2 2019/03/30 17:05:20 ist186507 Exp $ -*- c++ -*-
#ifndef __M19_RETURNNODE_H__
#define __M19_RETURNNODE_H__

#include <cdk/ast/expression_node.h>

namespace m19{
    
    class return_node : public cdk::basic_node {
        
    public:
        inline return_node(int lineno) : cdk::basic_node(lineno){
            
        }
        
    public:        
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_return_node(this, level);
        }
    };
}

#endif
