$LOAD_PATH.unshift File.expand_path("lib", __dir__)

require "grizzly"
require "byebug"
require "minitest/autorun"
require "benchmark"

class TestClassReturned < Minitest::Test
  def setup
    @array = (0..1000).to_a
    @collection = Grizzly::Collection.new @array
  end

  def test_class_returned_are_valid
    assert_equal Array, @array.select(&:odd?).class
    assert_equal Grizzly::Collection, @collection.select(&:odd?).class
  end
end

def run_benchmark(items:, iterations:, &block)
  puts
  array = (0..items).to_a
  collection = Grizzly::Collection.new array

  Benchmark.bm(70) do |x|
    x.report("List of length #{items} iterated over #{iterations} times - Array") { iterations.times { block.call array } }
    x.report("List of length #{items} iterated over #{iterations} times - Grizzly::Collection") { iterations.times { block.call collection } }
  end
end

def run_benchmarks(&block)
  n = 1
  while n <= 10_000
    limit = 5_000_000 / n
    run_benchmark(items:n, iterations: limit, &block)
    n *= 10
  end
end

puts
puts
puts "=== One method ==="
puts "{ |list| list.select(&:odd?) }"

run_benchmarks { |list| list.select(&:odd?) }

puts
puts
puts "=== Two chained methods ==="
puts "{ |list| list.select(&:odd?).reject(&:odd?) }"

run_benchmarks { |list| list.select(&:odd?).reject(&:odd?) }

puts
puts
puts "=== Chained enumerators ==="
puts "{ |list| list.select.each.select.reject(&:odd?) }"

run_benchmarks { |list| list.select.each.select.reject(&:odd?) }
