require "test_helper"

class Grizzly::CollectionTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Grizzly::VERSION
  end
end
