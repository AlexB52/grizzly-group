require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/collect_concat'

describe "Collection#collect_concat" do
  it_behaves_like :enumerable_collect_concat , :collect_concat
  it_behaves_like :enumeratorized_with_origin_size, :collect_concat, Group.new([1,2,3])

  it "doesn't return a subclass instance on Array subclasses" do
    Group.new([1,2,3,4]).collect_concat{|index| [1]}.should be_an_instance_of(Array)
  end
end
