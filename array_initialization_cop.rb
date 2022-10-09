require "rubocop"

module RuboCop
  module Cop
    module Style
      class ArrayInitialization < Base
        extend RuboCop::Cop::AutoCorrector

        ERROR_MSG = "an Array should not be initialized with the literal constructor []"

        def_node_matcher :array_literal, <<~PATTERN
          (array $...)
        PATTERN

        def_node_matcher :array_create, <<~PATTERN
          (send (const ...) :new (array ...))
        PATTERN

        def_node_matcher :array_spec_matched, <<~PATTERN
          (send (send ...) :== (array ...))
        PATTERN

        def on_array(node)
          expression = array_literal(node)
          return unless expression
          return if array_create(node.parent)
          return if array_spec_matched(node.parent)

          add_offense(node, message: ERROR_MSG) do |corrector|
            constant_to_replace = cop_config['InitializeArrayWith']
            array_items = expression.map(&:source).join(',')
            corrector.replace(node, "#{constant_to_replace}.new([#{array_items}])")
          end
        end
      end
    end
  end
end
