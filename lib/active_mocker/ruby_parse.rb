module ActiveMocker

  class RubyParse

    attr_reader :source

    def initialize(source)
      @source = source
    end

    def is_class?
      ast.type == :class
    end

    def class_name
      Unparser.unparse(ast.to_a[0])
    end

    def parent_class_name
      Unparser.unparse(ast.to_a[1])
    end

    def has_parent_class?
      return false if ast.to_a[1].nil?
      ast.to_a[1].type == :const
    end

    def change_class_name(class_name)
      reset_nodes
      nodes[0] = Parser::CurrentRuby.parse(class_name)
      new_ast = ast.updated(nil, nodes, nil)
      Unparser.unparse(new_ast)
    end

    def modify_parent_class(parent_class)
      reset_nodes
      if has_parent_class?
        nodes[1] = Parser::CurrentRuby.parse(parent_class)
        new_ast = ast.updated(nil, nodes, nil)
      else
        nodes[1] = nodes[0].updated(:const, [nil, parent_class.to_sym])
        new_ast = ast.updated(nil, nodes, nil)
      end
      Unparser.unparse(new_ast)
    end

    def ast
      @ast ||= Parser::CurrentRuby.parse(source)
    end

    def nodes
      @nodes ||= ast.to_a.dup
    end

    def reset_nodes
      @nodes = nil
    end

  end

end

