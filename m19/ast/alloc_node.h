// $Id: alloc_node.h,v 1.3 2019/03/20 18:54:35 ist186439 Exp $ -*- c++ -*-
#ifndef __M19_ALLOCNODE_H__
#define __M19_ALLOCNODE_H__

#include <cdk/ast/expression_node.h>

namespace m19{
    
    class alloc_node : public cdk::expression_node{
        
        cdk::expression_node *_size;
        
    public:
        inline alloc_node(int lineno, cdk::expression_node *size): expression_node(lineno), _size(size){
            
        }
        
    public:
        inline cdk::expression_node *size() {
            return _size;
        }
        
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_alloc_node(this, level);
        }
        
    };
    
}

#endif
