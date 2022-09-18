// $Id: section_node.h,v 1.3 2019/04/09 16:12:48 ist186507 Exp $ -*- c++ -*-
#ifndef __M19_SECTIONNODE_H__
#define __M19_SECTIONNODE_H__

#include "ast/block_node.h"
#include <cdk/ast/expression_node.h>

namespace m19 {
    
    class section_node: public cdk::basic_node{
        
        cdk::expression_node *_expression;
        m19::block_node *_block;
        int _type; //diz se a seccao e exclusiva [] _type = 0 ou inclusiva () _type = 1 ou _type = 2 a secccao so tem um bloco
        
    public:
        inline section_node(int lineno, cdk::expression_node *expression, m19::block_node *block, int type) : cdk::basic_node(lineno), _expression(expression), _block(block), _type(type) {
            
        }
        
        inline section_node(int lineno, m19::block_node *block) : cdk::basic_node(lineno), _block(block) {
            
        }
        

        
    public:
        inline cdk::expression_node *expression(){
            return _expression;
        }
        
        inline m19::block_node *block() {
            return _block;
        }
        
        inline int type() {
            return _type;
        }
        
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_section_node(this, level);
        }
    };
}

#endif
