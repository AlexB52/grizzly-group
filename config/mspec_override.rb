require "yaml"
require "singleton"
require_relative "../lib/grizzly"

class SkippedTests
  include Singleton

  attr_accessor :source

  def tests
    YAML.load(File.read(source))["tests"]
  end

  def skip?(block_details)
    tests.any? { |t| block_details.include?(t) }
  end
end

file_path = File.expand_path(File.dirname(__FILE__))
SkippedTests.instance.source = File.join(file_path, "skipped_tests.yml")

module MSpec
  def self.protect(location, &block)
    begin
      @env.instance_exec(&block)
      return true
    rescue SystemExit => e
      raise e
    rescue SkippedSpecError => e
      @skips << [e, block]
      return false
    rescue Object => exc
      return true if SkippedTests.instance.skip?(block.to_s)

      actions :exception, ExceptionState.new(current && current.state, location, exc)
      register_exit 1
      return false
    end
  end
end
