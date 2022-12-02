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

        def_node_matcher :array_initialization, <<~PATTERN
          (send (const nil? :Array) :new (array $...))
        PATTERN

        def_node_matcher :array_length_initialization, <<~PATTERN
          (send (const nil? :Array) :new $(int ...))
        PATTERN

        def on_send(node)
          expression = array_initialization(node)
          expression ||= array_length_initialization(node)

          return unless expression

          add_offense(node, message: ERROR_MSG) do |corrector|
            values = expression.is_a?(Array) ?  expression.map(&:value) : expression.value
            corrector.replace node, correction(values)
          end
        end

        def on_array(node)
          return unless (expression = array_literal(node))
          return if array_create(node.parent)
          return if array_spec_matched(node.parent)

          add_offense(node, message: ERROR_MSG) do |corrector|
            corrector.replace node, correction(expression.map(&:value))
          end
        end

        private

        def correction(values, constant_to_replace = cop_config['InitializeArrayWith'])
          "#{constant_to_replace}.new(#{values})"
        end
      end
    end
  end
end
