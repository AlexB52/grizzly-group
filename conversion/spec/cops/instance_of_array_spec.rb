require "spec_helper"

module RuboCop
  module Cop
    module Style
      describe InstanceOfArray, :config do
        include RuboCop::RSpec::ExpectOffense

        before do
          cop_config['NewInstanceOf'] = 'Grizzly::Collection'
        end

        it 'registers an offense when using instance_of(Array)' do
          expect_offense(<<~RUBY)
            be_an_instance_of(Array)
            ^^^^^^^^^^^^^^^^^^^^^^^^ instance_of should not be of Array
          RUBY

          expect_correction(<<~RUBY)
            be_an_instance_of(Grizzly::Collection)
          RUBY
        end

        it 'does not register an offense when for a random line' do
          expect_no_offenses(<<~RUBY)
            a.untrusted?.should be_true
          RUBY
        end

        it 'does not register an offense for other constant than Array' do
          expect_no_offenses(<<~RUBY)
            be_an_instance_of(Enumerator)
          RUBY
        end
      end
    end
  end
end
