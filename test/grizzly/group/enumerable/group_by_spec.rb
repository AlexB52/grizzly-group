require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/enumerable_enumeratorized'

describe :collection_group_by, shared: true do
  it "returns a hash with values grouped according to the block" do
    e = @subject.new(EnumerableSpecs::Numerous.new("foo", "bar", "baz"))
    h = e.group_by { |word| word[0..0].to_sym }
    h.should == { f: ["foo"], b: ["bar", "baz"]}
  end

  it "returns an empty hash for empty enumerables" do
    @subject.new(EnumerableSpecs::Empty.new).group_by { |x| x}.should == {}
  end

  it "returns a hash without default_proc" do
    e = @subject.new(EnumerableSpecs::Numerous.new("foo", "bar", "baz"))
    h = e.group_by { |word| word[0..0].to_sym }
    h[:some].should be_nil
    h.default_proc.should be_nil
    h.default.should be_nil
  end

  it "returns an Enumerator if called without a block" do
    @subject.new(EnumerableSpecs::Numerous.new).group_by.should be_an_instance_of(Enumerator)
  end

  # it "gathers whole arrays as elements when each yields multiple" do
  #   e = EnumerableSpecs::YieldsMulti.new
  #   h = e.group_by { |i| i }
  #   h.should == { [1, 2] => [[1, 2]],
  #                 [6, 7, 8, 9] => [[6, 7, 8, 9]],
  #                 [3, 4, 5] => [[3, 4, 5]] }
  # end

  ruby_version_is ''...'2.7' do
    it "returns a tainted hash if self is tainted" do
      @subject.new(EnumerableSpecs::Empty.new).taint.group_by {}.tainted?.should be_true
    end

    it "returns an untrusted hash if self is untrusted" do
      @subject.new(EnumerableSpecs::Empty.new).untrust.group_by {}.untrusted?.should be_true
    end
  end

  # it_behaves_like :enumerable_enumeratorized_with_origin_size, :group_by
end

describe "Array#group_by" do
  before { @subject = Array }

  it_behaves_like :collection_group_by, :group_by
  it_behaves_like :enumeratorized_with_origin_size, :group_by, Array.new([1,2,3,4,5])

  it "doesn't return subclass instance for each value on Array subclasses" do
    class MyArray < Array; end
    h = MyArray.new(["foo", "bar", "baz"]).group_by { |word| word[0..0].to_sym }

    h.should == { f: ["foo"], b: ["bar", "baz"]}
    h.values.all? {|subgroup| subgroup.is_a?(Array) }.should be_true
  end
end

describe "Collection#group_by" do
  before { @subject = Group }

  it_behaves_like :collection_group_by, :group_by
  it_behaves_like :enumeratorized_with_origin_size, :group_by, Group.new([1,2,3,4,5])

  it "returns subclass instance for each value on Array subclasses" do
    h = Group.new(["foo", "bar", "baz"]).group_by { |word| word[0..0].to_sym }

    h.should == { f: ["foo"], b: ["bar", "baz"]}
    h.values.all? {|subgroup| subgroup.is_a?(Group) }.should be_true
  end
end