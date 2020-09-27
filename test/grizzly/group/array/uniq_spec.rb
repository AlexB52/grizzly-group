require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_uniq, shared: true do
  it "returns an array with no duplicates" do
    @subject.new(["a", "a", "b", "b", "c"]).uniq.should == ["a", "b", "c"]
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty.uniq.should == [empty]

    array = CollectionSpecs.recursive_array(@subject)
    array.uniq.should == [1, 'two', 3.0, array]
  end

  it "uses eql? semantics" do
    @subject.new([1.0, 1]).uniq.should == [1.0, 1]
  end

  it "compares elements first with hash" do
    x = mock('0')
    x.should_receive(:hash).at_least(1).and_return(0)
    y = mock('0')
    y.should_receive(:hash).at_least(1).and_return(0)

    @subject.new([x, y]).uniq.should == [x, y]
  end

  it "does not compare elements with different hash codes via eql?" do
    x = mock('0')
    x.should_not_receive(:eql?)
    y = mock('1')
    y.should_not_receive(:eql?)

    x.should_receive(:hash).at_least(1).and_return(0)
    y.should_receive(:hash).at_least(1).and_return(1)

    @subject.new([x, y]).uniq.should == [x, y]
  end

  ruby_version_is '2.7' do
    it "compares elements with matching hash codes with #eql?" do
      # a = Array.new(2) do
      a = @subject.new(2) do
        obj = mock('0')
        obj.should_receive(:hash).at_least(1).and_return(0)

        def obj.eql?(o)
          false
        end

        obj
      end

      a.uniq.should == a

      # a = Array.new(2) do
      a = @subject.new(2) do
        obj = mock('0')
        obj.should_receive(:hash).at_least(1).and_return(0)

        def obj.eql?(o)
          true
        end

        obj
      end

      a.uniq.size.should == 1
    end
  end

  ruby_version_is ''...'2.7' do
    it "compares elements with matching hash codes with #eql?" do
      # a = Array.new(2) do
      a = @subject.new(2) do
        obj = mock('0')
        obj.should_receive(:hash).at_least(1).and_return(0)

        def obj.eql?(o)
          # It's undefined whether the impl does a[0].eql?(a[1]) or
          # a[1].eql?(a[0]) so we taint both.
          taint
          o.taint
          false
        end

        obj
      end

      a.uniq.should == a
      a[0].tainted?.should == true
      a[1].tainted?.should == true

      # a = Array.new(2) do
      a = @subject.new(2) do
        obj = mock('0')
        obj.should_receive(:hash).at_least(1).and_return(0)

        def obj.eql?(o)
          # It's undefined whether the impl does a[0].eql?(a[1]) or
          # a[1].eql?(a[0]) so we taint both.
          taint
          o.taint
          true
        end

        obj
      end

      a.uniq.size.should == 1
      a[0].tainted?.should == true
      a[1].tainted?.should == true
    end
  end

  it "compares elements based on the value returned from the block" do
    a = @subject.new([1, 2, 3, 4])
    a.uniq { |x| x >= 2 ? 1 : 0 }.should == [1, 2]
  end

  it "yields items in order" do
    a = @subject.new([1, 2, 3])
    yielded = []
    a.uniq { |v| yielded << v }
    yielded.should == a
  end

  it "handles nil and false like any other values" do
    @subject.new([nil, false, 42]).uniq { :foo }.should == [nil]
    @subject.new([false, nil, 42]).uniq { :bar }.should == [false]
  end

  # COLLECTION - Duplicated to matke it obvious
  it "returns subclass instance on Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].uniq.should be_an_instance_of(CollectionSpecs::MyArray)
  end

  it "properly handles an identical item even when its #eql? isn't reflexive" do
    x = mock('x')
    x.should_receive(:hash).at_least(1).and_return(42)
    x.stub!(:eql?).and_return(false) # Stubbed for clarity and latitude in implementation; not actually sent by MRI.

    @subject.new([x, x]).uniq.should == [x]
  end

  describe "given an array of BasicObject subclasses that define ==, eql?, and hash" do
    # jruby/jruby#3227
    it "filters equivalent elements using those definitions" do

      basic = Class.new(BasicObject) do
        attr_reader :x

        def initialize(x)
          @x = x
        end

        def ==(rhs)
          @x == rhs.x
        end
        alias_method :eql?, :==

        def hash
          @x.hash
        end
      end

      a = @subject.new [basic.new(3), basic.new(2), basic.new(1), basic.new(4), basic.new(1), basic.new(2), basic.new(3)]
      a.uniq.should == [basic.new(3), basic.new(2), basic.new(1), basic.new(4)]
    end
  end
end

describe :collection_uniq!, shared: true do
  it "modifies the array in place" do
    a = @subject.new [ "a", "a", "b", "b", "c" ]
    a.uniq!
    a.should == ["a", "b", "c"]
  end

  it "returns self" do
    a = @subject.new [ "a", "a", "b", "b", "c" ]
    a.should equal(a.uniq!)
  end

  it "properly handles recursive arrays" do
    empty = CollectionSpecs.empty_recursive_array(@subject)
    empty_dup = empty.dup
    empty.uniq!
    empty.should == empty_dup

    array = CollectionSpecs.recursive_array(@subject)
    expected = array[0..3]
    array.uniq!
    array.should == expected
  end

  it "compares elements first with hash" do
    x = mock('0')
    x.should_receive(:hash).at_least(1).and_return(0)
    y = mock('0')
    y.should_receive(:hash).at_least(1).and_return(0)

    a = @subject.new [x, y]
    a.uniq!
    a.should == [x, y]
  end

  it "does not compare elements with different hash codes via eql?" do
    x = mock('0')
    x.should_not_receive(:eql?)
    y = mock('1')
    y.should_not_receive(:eql?)

    x.should_receive(:hash).at_least(1).and_return(0)
    y.should_receive(:hash).at_least(1).and_return(1)

    a = @subject.new [x, y]
    a.uniq!
    a.should == [x, y]
  end

  it "returns nil if no changes are made to the array" do
    @subject.new([ "a", "b", "c" ]).uniq!.should == nil
  end

  it "raises a FrozenError on a frozen array when the array is modified" do
    dup_ary = @subject.new [1, 1, 2]
    dup_ary.freeze
    -> { dup_ary.uniq! }.should raise_error(FrozenError)
  end

  # see [ruby-core:23666]
  it "raises a FrozenError on a frozen array when the array would not be modified" do
    -> { CollectionSpecs.frozen_array(@subject).uniq!}.should raise_error(FrozenError)
    -> { CollectionSpecs.empty_frozen_array(@subject).uniq!}.should raise_error(FrozenError)
  end

  it "doesn't yield to the block on a frozen array" do
    -> { CollectionSpecs.frozen_array(@subject).uniq!{ raise RangeError, "shouldn't yield"}}.should raise_error(FrozenError)
  end

  it "compares elements based on the value returned from the block" do
    a = [1, 2, 3, 4]
    a.uniq! { |x| x >= 2 ? 1 : 0 }.should == [1, 2]
  end

  it "properly handles an identical item even when its #eql? isn't reflexive" do
    x = mock('x')
    x.should_receive(:hash).at_least(1).and_return(42)
    x.stub!(:eql?).and_return(false) # Stubbed for clarity and latitude in implementation; not actually sent by MRI.

    a = @subject.new [x, x]
    a.uniq!
    a.should == [x]
  end
end

describe "Array#uniq" do
  before { @subject = Array }

  it_behaves_like :collection_uniq, :uniq
  it_behaves_like :collection_uniq!, :uniq!

  it "returns subclass instance on Array subclasses" do
    CollectionSpecs::MyArray[1, 2, 3].uniq.should be_an_instance_of(CollectionSpecs::MyArray)
  end
end

describe "Collection#uniq" do
  before { @subject = Group }

  it_behaves_like :collection_uniq, :uniq
  it_behaves_like :collection_uniq!, :uniq!

  it "returns subclass instance on Array subclasses" do
    Group.new([1, 2, 3]).uniq.should be_an_instance_of(Group)
  end
end
