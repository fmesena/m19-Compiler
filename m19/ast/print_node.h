// $Id: print_node.h,v 1.5 2019/05/20 15:45:30 ist186507 Exp $ -*- c++ -*-
#ifndef __M19_PRINTNODE_H__
#define __M19_PRINTNODE_H__

#include <cdk/ast/expression_node.h>

namespace m19 {

  /**
   * Class for describing print nodes.
   */
  class print_node: public cdk::basic_node {
    cdk::expression_node *_argument;
    bool _newLine = false;  //print = false println = true

  public:
    inline print_node(int lineno, cdk::expression_node *argument, bool newLine = false) :
        cdk::basic_node(lineno), _argument(argument), _newLine(newLine) {
    }

  public:
    inline cdk::expression_node *argument() {
      return _argument;
    }
    
    inline bool newLine() {
      return _newLine;
    }

    void accept(basic_ast_visitor *sp, int level) {
      sp->do_print_node(this, level);
    }

  };

} // m19

#endif
