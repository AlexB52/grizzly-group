require "test_helper"

class Grizzly::CollectionTest < Minitest::Test
  class MyCollection < Grizzly::Collection; end

  def setup
    @subject = MyCollection.new (0..10).to_a
  end

  def test_each
    assert_instance_of Grizzly::Enumerator, @subject.each
  end
end
