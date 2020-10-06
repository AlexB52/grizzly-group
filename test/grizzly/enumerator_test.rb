require "test_helper"

class Grizzly::EnumeratorTest < Minitest::Test

  class MyGroup < Grizzly::Group; end

  def setup
    a = MyGroup.new (0..10).to_a
    @subject = Grizzly::Enumerator.new(a, :select)
  end
end
