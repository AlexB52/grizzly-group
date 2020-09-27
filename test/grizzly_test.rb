require "test_helper"

class Grizzly::GroupTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Grizzly::VERSION
  end
end
