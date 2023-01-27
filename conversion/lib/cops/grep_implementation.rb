module RuboCop
  module Cop
    module Style
      class GrepImplementation < Base
        extend RuboCop::Cop::AutoCorrector

        ERROR_MSG = "#grep and grep_v cannot be implemented"

        def_node_matcher :enumerable_grep_spec, <<~PATTERN
          (block (send nil? :describe (str "Enumerable#grep")) ...)
        PATTERN

        def_node_matcher :enumerable_grep_v_spec, <<~PATTERN
          (block (send nil? :describe (str "Enumerable#grep_v")) ...)
        PATTERN

        def_node_matcher :grep_spec_already_skipped, <<~PATTERN
          (block (send nil? :ruby_bug ...) ...)
        PATTERN

        def on_block(node)
          return if grep_spec_already_skipped(node.parent)
          return unless (expression = enumerable_grep_spec(node) || enumerable_grep_v_spec(node))

          add_offense(node, message: ERROR_MSG) do |corrector|
            corrector.replace node, <<~RUBY
              ruby_bug '#11808', ''...'#{cop_config['GrepSupportRubyVersion']}' do
              #{node.source}
              end
            RUBY
          end
        end
      end
    end
  end
end
