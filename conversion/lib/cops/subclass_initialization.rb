require "rubocop"

module RuboCop
  module Cop
    module Style
      class SubclassInitialization < Base
        extend RuboCop::Cop::AutoCorrector

        ERROR_MSG = "instance_of should not be of Array"

        def_node_matcher :sublclass_literal, <<~PATTERN
          (send (const (const ... ) :MyArray ) :[] $...)
        PATTERN

        def on_send(node)
          return unless (expression = sublclass_literal(node))

          add_offense(node, message: ERROR_MSG) do |corrector|
            constant_to_replace = cop_config['InitializeArrayWith']
            corrector.replace(node, "#{constant_to_replace}.new(#{expression.map(&:value)})")
          end
        end
      end
    end
  end
end


# (index
#     (const
#       (const nil :ArraySpecs) :MyArray)
#     (int 1)
#     (int 2)
#     (int 3)
#     (int 4)
#     (int 5)))


# s(:ivasgn, :@array,
#   s(:send,
#     s(:const,
#       s(:const, nil, :ArraySpecs), :MyArray), :[],
#     s(:int, 1),
#     s(:int, 2),
#     s(:int, 3),
#     s(:int, 4),
#     s(:int, 5)))