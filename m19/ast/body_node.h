// $Id: body_node.h,v 1.2 2019/04/06 15:18:39 ist186439 Exp $ -*- c++ -*-
#ifndef __M19_BODYNODE_H__
#define __M19_BODYNODE_H__

#include <cdk/ast/sequence_node.h>
#include "ast/initial_section_node.h"
#include "ast/section_node.h"
#include "ast/final_section_node.h"

namespace m19 {
    
    class body_node: public cdk::basic_node{
        
        m19::initial_section_node * _initial;
        cdk::sequence_node * _sections;
        m19::final_section_node * _final;
        
    public:
        inline body_node(int lineno, m19::initial_section_node *initial, cdk::sequence_node *sections, m19::final_section_node *fin) : cdk::basic_node(lineno), _initial(initial), _sections(sections), _final(fin) {
            
        }

    public:
        inline m19::initial_section_node *initial(){
            return _initial;
        }
        
        inline cdk::sequence_node *sections(){
            return _sections;
        }
        
        inline m19::final_section_node *fin(){
            return _final;
        }
        
        void accept(basic_ast_visitor *sp, int level) {
            sp->do_body_node(this, level);
        }
    };
}

#endif
