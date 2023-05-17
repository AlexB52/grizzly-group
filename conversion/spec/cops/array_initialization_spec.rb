require "spec_helper"

module RuboCop
  module Cop
    module Style
      describe ArrayInitialization, :config do
        include RuboCop::RSpec::ExpectOffense

        before do
          cop_config['InitializeArrayWith'] = 'AnotherClass'
        end

        it 'registers an offense for an array with nil @origin = [true, nil, false]' do
          expect_offense(<<~RUBY)
            @origin = [true, nil, false]
                      ^^^^^^^^^^^^^^^^^^ an Array should not be initialized with the literal constructor []
          RUBY

          expect_correction(<<~RUBY)
            @origin = AnotherClass.new([true, nil, false])
          RUBY
        end

        it 'registers an offense for @origin = [true, false]' do
          expect_offense(<<~RUBY)
            @origin = [true, false]
                      ^^^^^^^^^^^^^ an Array should not be initialized with the literal constructor []
          RUBY

          expect_correction(<<~RUBY)
            @origin = AnotherClass.new([true, false])
          RUBY
        end

        it 'registers an offense when using #to_a constructor' do
          expect_offense(<<~RUBY)
            a = (1..3).to_a
                ^^^^^^^^^^^ an Array should not be initialized with #to_a
          RUBY

          expect_correction(<<~RUBY)
            a = AnotherClass.new((1..3).to_a)
          RUBY
        end

        it 'registers an offense when using #to_a constructor on a chained method' do
          expect_offense(<<~RUBY)
            a = @array.combination(3).to_a
                ^^^^^^^^^^^^^^^^^^^^^^^^^^ an Array should not be initialized with #to_a
          RUBY

          expect_correction(<<~RUBY)
            a = AnotherClass.new(@array.combination(3).to_a)
          RUBY
        end

        it 'registers an offense when using [] literal constructor' do
          expect_offense(<<~RUBY)
            a = [1,2,3]
                ^^^^^^^ an Array should not be initialized with the literal constructor []
          RUBY
        end

        it 'registers an offense when using an Array initialization' do
          expect_offense(<<~RUBY)
            a = Array.new([1, 2, 3])
                ^^^^^^^^^^^^^^^^^^^^ an Array should not be initialized with .new
          RUBY

          expect_correction(<<~RUBY)
            a = AnotherClass.new([1, 2, 3])
          RUBY
        end

        it 'registers an offense when Array is instantiated with a length' do
          expect_offense(<<~RUBY)
            a = Array.new(1) {}
                ^^^^^^^^^^^^ an Array should not be initialized with .new
          RUBY

          expect_correction(<<~RUBY)
            a = AnotherClass.new(1) {}
          RUBY
        end

        it 'registers an offense when Array is instantiated with a length and a default value' do
          expect_offense(<<~RUBY)
            a = Array.new(99, "something")
                ^^^^^^^^^^^^^^^^^^^^^^^^^^ an Array should not be initialized with .new
          RUBY

          expect_correction(<<~RUBY)
            a = AnotherClass.new(99, "something")
          RUBY
        end

        it 'registers an offense when Array is instantiated with two variables' do
          expect_offense(<<~RUBY)
            a = Array.new(a, b)
                ^^^^^^^^^^^^^^^ an Array should not be initialized with .new
          RUBY

          expect_correction(<<~RUBY)
            a = AnotherClass.new(a, b)
          RUBY
        end

        it 'does not register an offense when doing a spec check' do
          expect_no_offenses(<<~RUBY)
            a == [1,2,3]
          RUBY
        end

        it 'corrects the offense by wrapping the array initialization with a class of choice' do
          expect_offense(<<~RUBY)
            a = [1,2,3]
                ^^^^^^^ an Array should not be initialized with the literal constructor []
          RUBY

          expect_correction(<<~RUBY)
            a = AnotherClass.new([1, 2, 3])
          RUBY
        end

        it 'corrects the offense that does not use the [] constrcution' do
          expect_offense(<<~RUBY)
            a = 1,2,3
                ^^^^^ an Array should not be initialized with the literal constructor []
          RUBY

          expect_correction(<<~RUBY)
            a = AnotherClass.new([1, 2, 3])
          RUBY
        end

        it 'corrects the offense that uses %w() construction' do
          expect_offense(<<~RUBY)
            a = %w(1 2 3)
                ^^^^^^^^^ an Array should not be initialized with the literal constructor []
          RUBY

          expect_correction(<<~RUBY)
            a = AnotherClass.new(["1", "2", "3"])
          RUBY
        end

        it 'corrects the offense with the constant configured in rubocop file' do
          old_config = cop_config['InitializeArrayWith'].dup
          cop_config['InitializeArrayWith'] = 'Collection'

          expect_offense(<<~RUBY)
            a = [1,2,3]
                ^^^^^^^ an Array should not be initialized with the literal constructor []
          RUBY

          expect_correction(<<~RUBY)
            a = Collection.new([1, 2, 3])
          RUBY

          cop_config['InitializeArrayWith'] = old_config
        end
      end
    end
  end
end
