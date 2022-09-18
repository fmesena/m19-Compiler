// $Id: address_node.h,v 1.3 2019/03/20 18:54:35 ist186439 Exp $ -*- c++ -*-
#ifndef __M19_ADDRESSNODE_H__
#define __M19_ADDRESSNODE_H__

#include <cdk/ast/expression_node.h>

namespace m19{
    
    class address_node : public cdk::expression_node {
        
        cdk::lvalue_node *_lvalue;
        
    public:
        address_node(int lineno, cdk::lvalue_node *lvalue) : cdk::expression_node(lineno), _lvalue(lvalue) {
            
        }
        
    public:
        cdk::lvalue_node *lvalue() {
            return _lvalue;
        }
        
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_address_node(this, level);
        }
    };
}

#endif
