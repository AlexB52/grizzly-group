require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/find'

describe "Array#find" do
  before { @subject = Array }

  it_behaves_like :enumerable_find , :find
  it_behaves_like :enumeratorized_with_unknown_size, :find, [1,2,3,4]
end

describe "Collection#find" do
  before { @subject = Group }

  it_behaves_like :enumerable_find , :find
  it_behaves_like :enumeratorized_with_unknown_size, :find, Group.new([1,2,3,4])
end
