module RuboCop
  module Cop
    module Style
      class ArrayInitialization < Base
        extend RuboCop::Cop::AutoCorrector

        ERROR_MSG_LITERAL = "an Array should not be initialized with the literal constructor []"
        ERROR_MSG_NEW = "an Array should not be initialized with .new"
        ERROR_MSG_TO_A = "an Array should not be initialized with #to_a"

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

        def_node_matcher :to_a_initialization, <<~PATTERN
          (send (...) :to_a)
        PATTERN

        def_node_matcher :to_a_already_parsed, <<~PATTERN
          (send $(...) :new (...))
        PATTERN

        def on_send(node)
          on_send_generic_initialization(node)
          on_send_to_a_initialization(node)
        end

        def on_send_generic_initialization(node)
          return unless (expression = generic_array_initialization(node))

          add_offense(node, message: ERROR_MSG_NEW) do |corrector|
            a, b = expression.map(&:source)
            corrector.replace node, format_correction(first: a , second: b)
          end
        end

        def on_send_to_a_initialization(node)
          return if to_a_already_parsed(node.parent)&.source == cop_config['InitializeArrayWith']
          return unless to_a_initialization(node)

          add_offense(node, message: ERROR_MSG_TO_A) do |corrector|
            corrector.replace node, format_correction(first: node.source)
          end
        end

        def on_array(node)
          return if array_create(node.parent)
          return if array_spec_matched(node.parent)
          return unless (expression = array_literal(node))

          add_offense(node, message: ERROR_MSG_LITERAL) do |corrector|
            corrector.replace node, format_correction(first: expression_to_string(expression))
          end
        end

        private

        def expression_to_string(expression)
          expression.map do |node|
            case node.type
            when :int
              node.value
            when :true
              true
            when :false
              false
            else
              node.value
            end
          end
        end

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
