require "spec_helper"

module RuboCop
  module Cop
    module Style
      describe GrepImplementation, :config do
        include RuboCop::RSpec::ExpectOffense

        before { cop_config['GrepSupportRubyVersion'] = '3.3' }

        it 'registers an offense for grep specs' do
          expect_offense(<<~RUBY)
            describe "Enumerable#grep" do
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #grep and grep_v cannot be implemented
              before :each do
                @a = EnumerableSpecs::EachDefiner.new( 2, 4, 6, 8, 10)
              end
            end
          RUBY

          expect_correction(<<~RUBY)
            ruby_bug '#11808', ''...'3.3' do
            describe "Enumerable#grep" do
              before :each do
                @a = EnumerableSpecs::EachDefiner.new( 2, 4, 6, 8, 10)
              end
            end
            end

          RUBY
        end

        it 'registers an offense for grep_v specs' do
          expect_offense(<<~RUBY)
            describe "Enumerable#grep_v" do
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ #grep and grep_v cannot be implemented
              before :each do
                @a = EnumerableSpecs::EachDefiner.new( 2, 4, 6, 8, 10)
              end
            end
          RUBY

          expect_correction(<<~RUBY)
            ruby_bug '#11808', ''...'3.3' do
            describe "Enumerable#grep_v" do
              before :each do
                @a = EnumerableSpecs::EachDefiner.new( 2, 4, 6, 8, 10)
              end
            end
            end

          RUBY
        end
      end
    end
  end
end
