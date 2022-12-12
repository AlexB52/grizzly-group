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

class YieldsMulti < Grizzly::Collection
  def each
    yield 1,2
    yield 3,4,5
    yield 6,7,8,9
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
