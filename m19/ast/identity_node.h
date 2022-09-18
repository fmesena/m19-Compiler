// $Id: identity_node.h,v 1.1 2019/03/20 17:36:27 ist186439 Exp $ -*- c++ -*-
#ifndef __M19_IDENTITYNODE_H__
#define __M19_IDENTITYNODE_H__

#include <cdk/ast/unary_expression_node.h>

namespace m19{
    
    class identity_node : public cdk::unary_expression_node {
        
    public:
        identity_node(int lineno, cdk::expression_node *arg) : unary_expression_node(lineno, arg) {
            
        }
    
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_identity_node(this, level);
        }
    
    };
}

#endif
