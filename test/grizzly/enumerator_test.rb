require "test_helper"

class Grizzly::EnumeratorTest < Minitest::Test

  class MyCollection < Grizzly::Collection; end

  def setup
    a = MyCollection.new (0..10).to_a
    @subject = Grizzly::Enumerator.new(a, :select)
  end
end
