// $Id: for_node.h,v 1.3 2019/03/19 16:25:49 ist186439 Exp $ -*- c++ -*-
#ifndef __M19_FORNODE_H__
#define __M19_FORNODE_H__

#include <cdk/ast/sequence_node.h>
#include <cdk/ast/basic_node.h>

namespace m19 {

  /**
   * Class for describing for nodes.
   */
  class for_node: public cdk::basic_node {
    cdk::sequence_node *_init;
    cdk::sequence_node *_condition;
    cdk::sequence_node *_inc;
    cdk::basic_node *_block;

  public:
    inline for_node(int lineno, cdk::sequence_node *init, cdk::sequence_node *condition, cdk::sequence_node *inc, cdk::basic_node *block) :
        basic_node(lineno), _init(init), _condition(condition), _inc(inc), _block(block) {
    }

  public:
    inline cdk::sequence_node *init() {
      return _init;
    }
    
    inline cdk::sequence_node *condition() {
      return _condition;
    }
    
    inline cdk::sequence_node *inc() {
      return _inc;
    }
    
    inline cdk::basic_node *block() {
      return _block;
    }

    void accept(basic_ast_visitor *sp, int level) {
      sp->do_for_node(this, level);
    }

  };

} // m19

#endif
