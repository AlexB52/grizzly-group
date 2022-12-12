require_relative "../../lib/grizzly"

# Running directly with ruby some_spec.rb
unless ENV['MSPEC_RUNNER']
  mspec_lib = File.expand_path("../../mspec/lib", __FILE__)
  $LOAD_PATH << mspec_lib if File.directory?(mspec_lib)

  begin
    require 'mspec'
    require 'mspec/commands/mspec-run'
  rescue LoadError
    puts "Please add -Ipath/to/mspec/lib or clone mspec as a sibling to run the specs."
    exit 1
  end

  ARGV.unshift $0
  MSpecRun.main
end

# Fixtures Array

class MyCollection < Grizzly::Collection; end

# Fixtures Enumerable

class Numerous
  include Grizzly::Enumerable
  attr_accessor :list
  def initialize(list = [2, 5, 3, 6, 1, 4])
    @list = list
  end

  def each
    @list.each { |i| yield i }
  end

  def ==(other)
    list == other.list
  end
end

class YieldsMulti
  include Grizzly::Enumerable

  attr_accessor :list
  def initialize(list = (1..9).to_a)
    @list = list
  end

  def ==(other)
    list == other.list
  end

  def each
    i = 2
    list = @list.dup
    until list.empty?
      yield *list.shift(i)
      i += 1
    end
  end
end

class ReverseComparable
  include Comparable
  def initialize(num)
    @num = num
  end

  attr_accessor :num

  # Reverse comparison
  def <=>(other)
    other.num <=> @num
  end
end
