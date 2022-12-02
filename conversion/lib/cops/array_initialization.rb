module RuboCop
  module Cop
    module Style
      class ArrayInitialization < Base
        extend RuboCop::Cop::AutoCorrector

        ERROR_MSG_LITERAL = "an Array should not be initialized with the literal constructor []"
        ERROR_MSG_NEW = "an Array should not be initialized with .new"

        def_node_matcher :array_literal, <<~PATTERN
          (array $...)
        PATTERN

        def_node_matcher :array_create, <<~PATTERN
          (send (const ...) :new (array ...))
        PATTERN

        def_node_matcher :array_spec_matched, <<~PATTERN
          (send (send ...) :== (array ...))
        PATTERN

        def_node_matcher :generic_array_initialization, <<~PATTERN
          (send (const nil? :Array) :new $...)
        PATTERN

        def on_send(node)
          return unless (expression = generic_array_initialization(node))

          add_offense(node, message: ERROR_MSG_NEW) do |corrector|
            a, b = expression.map(&:source)
            corrector.replace node, format_correction(first: a , second: b)
          end
        end

        def on_array(node)
          return unless (expression = array_literal(node))
          return if array_create(node.parent)
          return if array_spec_matched(node.parent)

          add_offense(node, message: ERROR_MSG_LITERAL) do |corrector|
            corrector.replace node, format_correction(first: expression.map(&:value))
          end
        end

        private

        def format_correction(first: nil, second: nil, constant: cop_config['InitializeArrayWith'])
          result = "#{constant}.new(#{first})"
          if second
            result = %Q{#{constant}.new(#{first}, #{second})}
          end
          result
        end
      end
    end
  end
end
