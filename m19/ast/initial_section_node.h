// $Id: initial_section_node.h,v 1.1 2019/03/21 14:07:19 ist186507 Exp $ -*- c++ -*-
#ifndef __M19_INITSECTIONNODE_H__
#define __M19_INITSECTIONNODE_H__

#include "ast/block_node.h"

namespace m19 {
    
    class initial_section_node: public cdk::basic_node{
        m19::block_node *_block;
        
    public:
        inline initial_section_node(int lineno, m19::block_node *block) : cdk::basic_node(lineno), _block(block) {
            
        }
        
    public:
        inline m19::block_node *block() {
            return _block;
        }
        
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_initial_section_node(this, level);
        }
    };
}

#endif
