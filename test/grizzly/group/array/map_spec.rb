require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/collect'
require_relative '../enumerable/shared/enumeratorized'


describe "Array#map" do
  before { @subject = Array }

  it_behaves_like :array_collect, :map

  before :all do
    @object = [1, 2, 3, 4]
  end
  it_should_behave_like :enumeratorized_with_origin_size
end

describe "Array#map!" do
  before { @subject = Array }

  it_behaves_like :array_collect_b, :map!

  before :all do
    @object = [1, 2, 3, 4]
  end
  it_should_behave_like :enumeratorized_with_origin_size
end

describe "Collection#map" do
  before { @subject = Group }

  it_behaves_like :array_collect, :map

  before :all do
    @object = Group.new([1, 2, 3, 4])
  end
  it_should_behave_like :enumeratorized_with_origin_size
end

describe "Collection#map!" do
  before { @subject = Group }

  it_behaves_like :array_collect_b, :map!

  before :all do
    @object = Group.new([1, 2, 3, 4])
  end
  it_should_behave_like :enumeratorized_with_origin_size
end
