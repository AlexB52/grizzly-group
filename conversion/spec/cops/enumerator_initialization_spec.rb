require "spec_helper"

module RuboCop
  module Cop
    module Style
      describe EnumeratorInitialization, :config do
        include RuboCop::RSpec::ExpectOffense

        before do
          cop_config['InitializeEnumeratorWith'] = 'AnotherEnumerator'
        end

        it 'registers an offense for chained to_enum' do
          expect_offense(<<~RUBY)
            @enum = EnumeratorSpecs::Feed.new.to_enum(:each)
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #to_enum initialization needs to be wrapped
          RUBY

          expect_correction(<<~RUBY)
            @enum = AnotherEnumerator.new(EnumeratorSpecs::Feed.new.to_enum(:each))
          RUBY
        end

        it 'registers an offense for simple case' do
          expect_offense(<<~RUBY)
            @e = o.to_enum
                 ^^^^^^^^^ #to_enum initialization needs to be wrapped
          RUBY

          expect_correction(<<~RUBY)
            @e = AnotherEnumerator.new(o.to_enum)
          RUBY
        end

        it 'registers an offense for simple case with args' do
          expect_offense(<<~RUBY)
            @enum_with_arguments = object_each_with_arguments.to_enum(:each_with_arguments, :arg0, :arg1, :arg2)
                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #to_enum initialization needs to be wrapped
          RUBY

          expect_correction(<<~RUBY)
            @enum_with_arguments = AnotherEnumerator.new(object_each_with_arguments.to_enum(:each_with_arguments, :arg0, :arg1, :arg2))
          RUBY
        end

        it 'registers an offense for Enumerator initialized with blocks' do
          expect_offense(<<~RUBY)
            @e = Enumerator.new {|y| y.yield :ok}
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #new Enumerator initialization needs to be wrapped
          RUBY

          expect_correction(<<~RUBY)
            @e = AnotherEnumerator.new(Enumerator.new {|y| y.yield :ok})
          RUBY
        end

        it 'registers an offense for Enumerator initialized with blocks and arguments' do
          expect_offense(<<~RUBY)
            @e = Enumerator.new(100) {}
                 ^^^^^^^^^^^^^^^^^^^^^^ #new Enumerator initialization needs to be wrapped
          RUBY

          expect_correction(<<~RUBY)
            @e = AnotherEnumerator.new(Enumerator.new(100) {})
          RUBY
        end

        it 'registers an offense for Enumerator initialized with arguments (ruby 2.7)' do
          # Enumerator.new(1, :upto, 3)

          expect_offense(<<~RUBY)
            @e = Enumerator.new(1, :upto, 3)
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^ #new Enumerator initialization needs to be wrapped
          RUBY

          expect_correction(<<~RUBY)
            @e = AnotherEnumerator.new(Enumerator.new(1, :upto, 3))
          RUBY

          # Enumerator.new(1..2)

          expect_offense(<<~RUBY)
            @e = Enumerator.new(1..2)
                 ^^^^^^^^^^^^^^^^^^^^ #new Enumerator initialization needs to be wrapped
          RUBY

          expect_correction(<<~RUBY)
            @e = AnotherEnumerator.new(Enumerator.new(1..2))
          RUBY

          # Enumerator.new(1..2, :each)

          expect_offense(<<~RUBY)
            @e = Enumerator.new(1..2, :each)
                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^ #new Enumerator initialization needs to be wrapped
          RUBY

          expect_correction(<<~RUBY)
            @e = AnotherEnumerator.new(Enumerator.new(1..2, :each))
          RUBY
        end
      end
    end
  end
end
