// $Id: index_node.h,v 1.4 2019/05/24 09:54:06 ist186439 Exp $ -*- c++ -*-
#ifndef __M19_INDEXNODE_H__
#define __M19_INDEXNODE_H__

#include <cdk/ast/expression_node.h>
#include <cdk/ast/lvalue_node.h>

namespace m19{
    
    class index_node : public cdk::lvalue_node {
        cdk::expression_node *_pointer;
        cdk::expression_node *_index;
       
        
    public:
        inline index_node(int lineno, cdk::expression_node *pointer, cdk::expression_node *index) : cdk::lvalue_node(lineno), _pointer(pointer), _index(index) {
        }
    
    public:
        cdk::expression_node *index() {
            return _index;
        }
        
        cdk::expression_node *pointer() {
            return _pointer;
        }
        
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_index_node(this, level);
        }
    };
}

#endif
