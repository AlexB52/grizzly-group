module RuboCop
  module Cop
    module Style
      class EnumeratorInitialization < Base
        extend RuboCop::Cop::AutoCorrector

        ERROR_MSG_TO_ENUM = "#to_enum initialization needs to be wrapped"
        ERROR_MSG_NEW = "#new Enumerator initialization needs to be wrapped"

        def_node_matcher :already_wrapped, <<~PATTERN
          (send $(...) :new (...))
        PATTERN

        def_node_matcher :to_enum_initialization, <<~PATTERN
          (send (...) :to_enum ...)
        PATTERN


        def_node_matcher :new_initialization, <<~PATTERN
          (send (const nil? :Enumerator) :new ...)
        PATTERN

        def_node_matcher :new_block_initialization, <<~PATTERN
          (block (send (const nil? :Enumerator) :new ...) ...)
        PATTERN

        def on_send(node)
          return if already_wrapped(node.parent)&.source == cop_config['InitializeEnumeratorWith']
          return if new_block_initialization(node.parent)

          error = case
            when to_enum_initialization(node) then ERROR_MSG_TO_ENUM
            when new_initialization(node)     then ERROR_MSG_NEW
            end

          return unless error

          add_offense(node, message: error) do |corrector|
            constant = cop_config['InitializeEnumeratorWith']
            corrector.replace node, "#{constant}.new(#{node.source})"
          end
        end

        def on_block(node)
          return if already_wrapped(node.parent)&.source == cop_config['InitializeEnumeratorWith']
          return unless new_block_initialization(node)

          add_offense(node, message: ERROR_MSG_NEW) do |corrector|
            constant = cop_config['InitializeEnumeratorWith']
            corrector.replace node, "#{constant}.new(#{node.source})"
          end
        end
      end
    end
  end
end
