#ifndef __M19_SEMANTICS_POSTFIX_WRITER_H__
#define __M19_SEMANTICS_POSTFIX_WRITER_H__

#include <string>
#include <stack>
#include <set>
#include <iostream>
#include <stack>
#include <cdk/symbol_table.h>
#include <cdk/emitters/basic_postfix_emitter.h>
#include "targets/basic_ast_visitor.h"
#include "targets/symbol.h"

namespace m19 {

  //!
  //! Traverse syntax tree and generate the corresponding assembly code.
  //!
  class postfix_writer: public basic_ast_visitor {
    cdk::symbol_table<m19::symbol> &_symtab;
    cdk::basic_postfix_emitter &_pf;
    int _lbl;
    bool _inFunctionBody = false, _inFunctionArgs = false, _inFinalSection = false;
    std::shared_ptr<m19::symbol> _function;
    int _offset;
    std::stack<int> _forCondit, _forIncr, _forEnd;
    std::set<std::string> _functions_to_declare;

  public:
    postfix_writer(std::shared_ptr<cdk::compiler> compiler, cdk::symbol_table<m19::symbol> &symtab,
                   cdk::basic_postfix_emitter &pf) :
        basic_ast_visitor(compiler), _symtab(symtab), _pf(pf), _lbl(0), _function(nullptr), _offset(0) {
    }

  public:
    ~postfix_writer() {
      os().flush();
    }

  private:
    /** Method used to generate sequential labels. */
    inline std::string mklbl(int lbl) {
      std::ostringstream oss;
      if (lbl < 0)
        oss << ".L" << -lbl;
      else
        oss << "_L" << lbl;
      return oss.str();
    }

  public:
  // do not edit these lines
#define __IN_VISITOR_HEADER__
#include "ast/visitor_decls.h"       // automatically generated
#undef __IN_VISITOR_HEADER__
  // do not edit these lines: end

  };

} // m19

#endif
