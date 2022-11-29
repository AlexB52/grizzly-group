module RuboCop
  module Cop
    module Style
      class InstanceOfArray < Base
        extend RuboCop::Cop::AutoCorrector

        ERROR_MSG = "instance_of should not be of Array"

        def_node_matcher :instance_of_literal, <<~PATTERN
          (send nil? :be_an_instance_of (const nil? :Array))
        PATTERN

        def on_send(node)
          return unless instance_of_literal(node)

          add_offense(node, message: ERROR_MSG) do |corrector|
            constant_to_replace = cop_config['NewInstanceOf']
            corrector.replace(node, "be_an_instance_of(#{constant_to_replace})")
          end
        end
      end
    end
  end
end
