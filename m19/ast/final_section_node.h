// $Id: final_section_node.h,v 1.1 2019/03/21 14:17:48 ist186507 Exp $ -*- c++ -*-
#ifndef __M19_FINALSECTIONNODE_H__
#define __M19_FINALSECTIONNODE_H__

#include "ast/block_node.h"

namespace m19 {
    
    class final_section_node: public cdk::basic_node{
        m19::block_node *_block;
        
    public:
        inline final_section_node(int lineno, m19::block_node *block) : cdk::basic_node(lineno), _block(block) {
            
        }
        
    public:
        inline m19::block_node *block() {
            return _block;
        }
        
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_final_section_node(this, level);
        }
    };
}

#endif
