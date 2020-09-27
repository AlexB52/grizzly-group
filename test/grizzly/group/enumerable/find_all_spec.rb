require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/find_all'

describe "Enumerable#find_all" do
  it_behaves_like :enumerable_find_all , :find_all

  # New Interface
  it_should_behave_like :enumeratorized_with_origin_size

  it "returns subclass instance on Array subclasses" do
    Group.new([1,2,3,4]).find_all { true }.should be_an_instance_of(Group)
  end
end
