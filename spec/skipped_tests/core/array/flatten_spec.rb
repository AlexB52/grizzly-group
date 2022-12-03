require_relative '../../spec_helper'

describe "Array#flatten" do
  ruby_version_is ''...'3.0' do
    # core/array/flatten_spec.rb:79
    it "returns subclass instance for Array subclasses" do
      MyCollection[].flatten.should be_an_instance_of(MyCollection)
      MyCollection[1, 2, 3].flatten.should be_an_instance_of(MyCollection)
      MyCollection[1, Grizzly::Collection.new([2]), 3].flatten.should be_an_instance_of(MyCollection)
      MyCollection[1, Grizzly::Collection.new([2, 3]), 4].flatten.should == MyCollection[1, 2, 3, 4]
      [MyCollection[1, 2, 3]].flatten.should be_an_instance_of(Array)
    end
  end

  ruby_version_is '3.0' do
    it "returns subclass instance for Array subclasses" do
      MyCollection[].flatten.should be_an_instance_of(MyCollection)
      MyCollection[1, 2, 3].flatten.should be_an_instance_of(MyCollection)
      MyCollection[1, Grizzly::Collection.new([2]), 3].flatten.should be_an_instance_of(MyCollection)
      MyCollection[1, Grizzly::Collection.new([2, 3]), 4].flatten.should == [1, 2, 3, 4]
      [MyCollection[1, 2, 3]].flatten.should be_an_instance_of(Array)
    end
  end
end

describe "Array#flatten!" do
  # core/array/flatten_spec.rb:248
  it "flattens any elements which responds to #to_ary, using the return value of said method" do
    x = mock("[3,4]")
    x.should_receive(:to_ary).at_least(:once).and_return(Grizzly::Collection.new([3, 4]))
    [1, 2, x, 5].flatten!.should == [1, 2, 3, 4, 5]

    y = mock("MyArray[]")
    y.should_receive(:to_ary).at_least(:once).and_return(MyCollection[])
    [y].flatten!.should == []

    z = mock("[2,x,y,5]")
    z.should_receive(:to_ary).and_return([2, x, y, 5])
    [1, z, 6].flatten!.should == [1, 2, 3, 4, 5, 6]

    ary = [MyCollection[1, 2, 3]]
    ary.flatten!
    ary.should be_an_instance_of(Array)
    ary.should == [1, 2, 3]
  end
end