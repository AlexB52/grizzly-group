require "spec_helper"

module RuboCop
  module Cop
    module Style
      describe SubclassInitialization, :config do
        include RuboCop::RSpec::ExpectOffense

        before do
          cop_config['InitializeArrayWith'] = 'Grizzly::Collection'
        end

        it 'registers an offense when using instance_of(Array)' do
          expect_offense(<<~RUBY)
            MyModule::MyArray[1,2,3]
            ^^^^^^^^^^^^^^^^^^^^^^^^ instance_of should not be of Array
          RUBY

          expect_correction(<<~RUBY)
            Grizzly::Collection.new([1, 2, 3])
          RUBY
        end
      end
    end
  end
end
