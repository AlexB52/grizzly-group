require "test_helper"

class Grizzly::GroupTest < Minitest::Test
  class MyGroup < Grizzly::Group; end

  def setup
    @subject = MyGroup.new (0..10).to_a
  end

  def test_each
    assert_instance_of Grizzly::Enumerator, @subject.each
  end
end
