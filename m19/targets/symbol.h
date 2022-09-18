#ifndef __M19_SEMANTICS_SYMBOL_H__
#define __M19_SEMANTICS_SYMBOL_H__

#include <string>
#include <vector>
#include <cdk/basic_type.h>

namespace m19 {

  class symbol {
    basic_type *_type;
    std::string _name;
    long _value; // hack!
    int _qualifier;
    bool _initializer; //symbol is a variable: true if has init value; symbol is a function: true if has a default return value; 
    int _offset = 0;
    bool _function; //false for variables
    bool _forward = false;
    
    //std::vector<basic_type *> _args;
    std::vector<int> _args;

  public:
    symbol(basic_type *type, const std::string &name, int qualifier, bool init, bool function, bool forward = false) :
        _type(type), _name(name), _value(0), _qualifier(qualifier), _initializer(init), _function(function), _forward(forward) {
    }

    virtual ~symbol() {
        delete _type;
    }
    
    basic_type *type() const {
      return _type;
    }
    const std::string &name() const {
      return _name;
    }
    long value() const {
      return _value;
    }
    long value(long v) {
      return _value = v;
    }
    bool init() const{
        return _initializer;
    }
    bool init(bool i){
        return _initializer = i;
    }
    int offset() const{
        return _offset;
    }
    int offset(int o){
        return _offset = o;
    }
    
    int isGlobal() const{
        return _offset == 0;
    }
    bool isFunction() const{
        return _function;
    }
    bool isVariable() const{
        return !_function;
    }
    bool function(bool f){
        return _function = f;
    }
    bool forward() const{
        return _forward;
    }
    bool forward(bool fw){
        return _forward = fw;
    }
    
    int qualifier() const{
        return _qualifier;
    }
    int qualifier(int q){
        return _qualifier = q;
    }
    
    
    /*std::vector<basic_type *> args() const {
        return _args;
    }
    
    int args(basic_type *arg) {
        _args.push_back(arg);
        return _args.size();

    }
    
    basic_type *elem (int i) {
        if(_args.at(i) == nullptr)
            std::cout << "E NULLLLLLLLLL" << std::endl;
        return _args.at(i);
    } */
    
    
    std::vector<int> args() const {
        return _args;
    }
    
    int args(int arg) {
        _args.push_back(arg);
        return _args.size();

    }
    
    int elem (int i) {
        return _args.at(i);
    } 
  };

} // m19

#endif
