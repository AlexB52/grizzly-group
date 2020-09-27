require_relative '../../../spec_helper'
require_relative 'fixtures/classes'

describe :collection_element_set, shared: true do
  it "sets the value of the element at index" do
    a = @subject.new([1, 2, 3, 4])
    a[2] = 5
    a[-1] = 6
    a[5] = 3
    a.should == [1, 2, 5, 6, nil, 3]

    a = @subject.new([])
    a[4] = "e"
    a.should == [nil, nil, nil, nil, "e"]
    a[3] = "d"
    a.should == [nil, nil, nil, "d", "e"]
    a[0] = "a"
    a.should == ["a", nil, nil, "d", "e"]
    a[-3] = "C"
    a.should == ["a", nil, "C", "d", "e"]
    a[-1] = "E"
    a.should == ["a", nil, "C", "d", "E"]
    a[-5] = "A"
    a.should == ["A", nil, "C", "d", "E"]
    a[5] = "f"
    a.should == ["A", nil, "C", "d", "E", "f"]
    a[1] = []
    a.should == ["A", [], "C", "d", "E", "f"]
    a[-1] = nil
    a.should == ["A", [], "C", "d", "E", nil]
  end

  it "sets the section defined by [start,length] to other" do
    a = @subject.new([1, 2, 3, 4, 5, 6])
    a[0, 1] = 2
    a[3, 2] = ['a', 'b', 'c', 'd']
    a.should == [2, 2, 3, "a", "b", "c", "d", 6]
  end
  it "replaces the section defined by [start,length] with the given values" do
    a = @subject.new([1, 2, 3, 4, 5, 6])
    a[3, 2] = 'a', 'b', 'c', 'd'
    a.should == [1, 2, 3, "a", "b", "c", "d", 6]
  end

  it "just sets the section defined by [start,length] to other even if other is nil" do
    a = @subject.new(['a', 'b', 'c', 'd', 'e'])
    a[1, 3] = nil
    a.should == ["a", nil, "e"]
  end

  it "returns nil if the rhs is nil" do
    a = @subject.new([1, 2, 3])
    (a[1, 3] = nil).should == nil
    (a[1..3] = nil).should == nil
  end

  it "sets the section defined by range to other" do
    a = @subject.new([6, 5, 4, 3, 2, 1])
    a[1...2] = 9
    a[3..6] = [6, 6, 6]
    a.should == [6, 9, 4, 6, 6, 6]
  end

  it "replaces the section defined by range with the given values" do
    a = @subject.new([6, 5, 4, 3, 2, 1])
    a[3..6] = :a, :b, :c
    a.should == [6, 5, 4, :a, :b, :c]
  end

  it "just sets the section defined by range to other even if other is nil" do
    a = @subject.new([1, 2, 3, 4, 5])
    a[0..1] = nil
    a.should == [nil, 3, 4, 5]
  end

  it 'expands and nil-pads the array if section assigned by range is outside array boundaries' do
    a = @subject.new(['a'])
    a[3..4] = ['b', 'c']
    a.should == ['a', nil, nil, 'b', 'c']
  end

  it "calls to_int on its start and length arguments" do
    obj = mock('to_int')
    obj.stub!(:to_int).and_return(2)

    a = @subject.new([1, 2, 3, 4])
    a[obj, 0] = [9]
    a.should == [1, 2, 9, 3, 4]
    a[obj, obj] = []
    a.should == [1, 2, 4]
    a[obj] = -1
    a.should == [1, 2, -1]
  end

  it "checks frozen before attempting to coerce arguments" do
    a = @subject.new([1,2,3,4]).freeze
    -> {a[:foo] = 1}.should raise_error(FrozenError)
    -> {a[:foo, :bar] = 1}.should raise_error(FrozenError)
  end

  it "sets elements in the range arguments when passed ranges" do
    ary = @subject.new([1, 2, 3])
    rhs = [nil, [], ["x"], ["x", "y"]]
    (0 .. ary.size + 2).each do |a|
      (a .. ary.size + 3).each do |b|
        rhs.each do |c|
          ary1 = ary.dup
          ary1[a .. b] = c
          ary2 = ary.dup
          ary2[a, 1 + b-a] = c
          ary1.should == ary2

          ary1 = ary.dup
          ary1[a ... b] = c
          ary2 = ary.dup
          ary2[a, b-a] = c
          ary1.should == ary2
        end
      end
    end
  end

  it "inserts the given elements with [range] which the range is zero-width" do
    ary = @subject.new([1, 2, 3])
    ary[1...1] = 0
    ary.should == [1, 0, 2, 3]
    ary[1...1] = [5]
    ary.should == [1, 5, 0, 2, 3]
    ary[1...1] = :a, :b, :c
    ary.should == [1, :a, :b, :c, 5, 0, 2, 3]
  end

  it "inserts the given elements with [start, length] which length is zero" do
    ary = @subject.new([1, 2, 3])
    ary[1, 0] = 0
    ary.should == [1, 0, 2, 3]
    ary[1, 0] = [5]
    ary.should == [1, 5, 0, 2, 3]
    ary[1, 0] = :a, :b, :c
    ary.should == [1, :a, :b, :c, 5, 0, 2, 3]
  end

  # Now we only have to test cases where the start, length interface would
  # have raise an exception because of negative size
  it "inserts the given elements with [range] which the range has negative width" do
    ary = @subject.new([1, 2, 3])
    ary[1..0] = 0
    ary.should == [1, 0, 2, 3]
    ary[1..0] = [4, 3]
    ary.should == [1, 4, 3, 0, 2, 3]
    ary[1..0] = :a, :b, :c
    ary.should == [1, :a, :b, :c, 4, 3, 0, 2, 3]
  end

  it "just inserts nil if the section defined by range is zero-width and the rhs is nil" do
    ary = @subject.new([1, 2, 3])
    ary[1...1] = nil
    ary.should == [1, nil, 2, 3]
  end

  it "just inserts nil if the section defined by range has negative width and the rhs is nil" do
    ary = @subject.new([1, 2, 3])
    ary[1..0] = nil
    ary.should == [1, nil, 2, 3]
  end

  it "does nothing if the section defined by range is zero-width and the rhs is an empty array" do
    ary = @subject.new([1, 2, 3])
    ary[1...1] = []
    ary.should == [1, 2, 3]
  end
  it "does nothing if the section defined by range has negative width and the rhs is an empty array" do
    ary = @subject.new([1, 2, 3, 4, 5])
    ary[1...0] = []
    ary.should == [1, 2, 3, 4, 5]
    ary[-2..2] = []
    ary.should == [1, 2, 3, 4, 5]
  end

  it "tries to convert Range elements to Integers using #to_int with [m..n] and [m...n]" do
    from = mock('from')
    to = mock('to')

    # So we can construct a range out of them...
    def from.<=>(o) 0 end
    def to.<=>(o) 0 end

    def from.to_int() 1 end
    def to.to_int() -2 end

    a = @subject.new([1, 2, 3, 4])

    a[from .. to] = ["a", "b", "c"]
    a.should == [1, "a", "b", "c", 4]

    a[to .. from] = ["x"]
    a.should == [1, "a", "b", "x", "c", 4]
    -> { a["a" .. "b"] = []  }.should raise_error(TypeError)
    -> { a[from .. "b"] = [] }.should raise_error(TypeError)
  end

  it "raises an IndexError when passed indexes out of bounds" do
    a = @subject.new([1, 2, 3, 4])
    -> { a[-5] = ""      }.should raise_error(IndexError)
    -> { a[-5, -1] = ""  }.should raise_error(IndexError)
    -> { a[-5, 0] = ""   }.should raise_error(IndexError)
    -> { a[-5, 1] = ""   }.should raise_error(IndexError)
    -> { a[-5, 2] = ""   }.should raise_error(IndexError)
    -> { a[-5, 10] = ""  }.should raise_error(IndexError)

    -> { a[-5..-5] = ""  }.should raise_error(RangeError)
    -> { a[-5...-5] = "" }.should raise_error(RangeError)
    -> { a[-5..-4] = ""  }.should raise_error(RangeError)
    -> { a[-5...-4] = "" }.should raise_error(RangeError)
    -> { a[-5..10] = ""  }.should raise_error(RangeError)
    -> { a[-5...10] = "" }.should raise_error(RangeError)

    # ok
    a[0..-9] = [1]
    a.should == [1, 1, 2, 3, 4]
  end

  it "calls to_ary on its rhs argument for multi-element sets" do
    obj = mock('to_ary')
    def obj.to_ary() [1, 2, 3] end
    ary = @subject.new([1, 2])
    ary[0, 0] = obj
    ary.should == [1, 2, 3, 1, 2]
    ary[1, 10] = obj
    ary.should == [1, 1, 2, 3]
  end

  it "does not call to_ary on rhs array subclasses for multi-element sets" do
    ary = @subject.new([])
    ary[0, 0] = CollectionSpecs::ToAryArray[5, 6, 7]
    ary.should == [5, 6, 7]
  end

  it "raises a FrozenError on a frozen array" do
    -> { CollectionSpecs.frozen_array(@subject)[0, 0] = [] }.should raise_error(FrozenError)
  end
end

describe :collection_element_set_with_index, shared: true do
  it "returns value assigned if idx is inside array" do
    a = @subject.new([1, 2, 3, 4, 5])
    (a[3] = 6).should == 6
  end

  it "returns value assigned if idx is right beyond right array boundary" do
    a = @subject.new([1, 2, 3, 4, 5])
    (a[5] = 6).should == 6
  end

  it "returns value assigned if idx far beyond right array boundary" do
    a = @subject.new([1, 2, 3, 4, 5])
    (a[10] = 6).should == 6
  end

  it "sets the value of the element at index" do
    a = @subject.new([1, 2, 3, 4])
    a[2] = 5
    a[-1] = 6
    a[5] = 3
    a.should == [1, 2, 5, 6, nil, 3]
  end

  it "sets the value of the element if it is right beyond the array boundary" do
    a = @subject.new([1, 2, 3, 4])
    a[4] = 8
    a.should == [1, 2, 3, 4, 8]
  end
end

describe :collection_element_set_with_index_count, shared: true do
  it "returns non-array value if non-array value assigned" do
    a = @subject.new([1, 2, 3, 4, 5])
    (a[2, 3] = 10).should == 10
  end

  it "returns array if array assigned" do
    a = @subject.new([1, 2, 3, 4, 5])
    (a[2, 3] = [4, 5]).should == [4, 5]
  end

  it "just sets the section defined by [start,length] to nil even if the rhs is nil" do
    a = @subject.new(['a', 'b', 'c', 'd', 'e'])
    a[1, 3] = nil
    a.should == ["a", nil, "e"]
  end

  it "just sets the section defined by [start,length] to nil if negative index within bounds, cnt > 0 and the rhs is nil" do
    a = @subject.new(['a', 'b', 'c', 'd', 'e'])
    a[-3, 2] = nil
    a.should == ["a", "b", nil, "e"]
  end

  it "replaces the section defined by [start,length] to other" do
    a = @subject.new([1, 2, 3, 4, 5, 6])
    a[0, 1] = 2
    a[3, 2] = ['a', 'b', 'c', 'd']
    a.should == [2, 2, 3, "a", "b", "c", "d", 6]
  end

  it "replaces the section to other if idx < 0 and cnt > 0" do
    a = @subject.new([1, 2, 3, 4, 5, 6])
    a[-3, 2] = ["x", "y", "z"]
    a.should == [1, 2, 3, "x", "y", "z", 6]
  end

  it "replaces the section to other even if cnt spanning beyond the array boundary" do
    a = @subject.new([1, 2, 3, 4, 5])
    a[-1, 3] = [7, 8]
    a.should == [1, 2, 3, 4, 7, 8]
  end

  it "pads the Array with nils if the span is past the end" do
    a = @subject.new([1, 2, 3, 4, 5])
    a[10, 1] = [1]
    a.should == [1, 2, 3, 4, 5, nil, nil, nil, nil, nil, 1]

    b = [1, 2, 3, 4, 5]
    b[10, 0] = [1]
    a.should == [1, 2, 3, 4, 5, nil, nil, nil, nil, nil, 1]
  end

  it "inserts other section in place defined by idx" do
    a = @subject.new([1, 2, 3, 4, 5])
    a[3, 0] = [7, 8]
    a.should == [1, 2, 3, 7, 8, 4, 5]

    b = [1, 2, 3, 4, 5]
    b[1, 0] = b
    b.should == [1, 1, 2, 3, 4, 5, 2, 3, 4, 5]
  end

  it "raises an IndexError when passed start and negative length" do
    a = @subject.new([1, 2, 3, 4])
    -> { a[-2, -1] = "" }.should raise_error(IndexError)
    -> { a[0, -1] = ""  }.should raise_error(IndexError)
    -> { a[2, -1] = ""  }.should raise_error(IndexError)
    -> { a[4, -1] = ""  }.should raise_error(IndexError)
    -> { a[10, -1] = "" }.should raise_error(IndexError)
    -> { [1, 2, 3, 4,  5][2, -1] = [7, 8] }.should raise_error(IndexError)
  end
end

describe :collection_element_set_with_range, shared: true do
  it "returns non-array value if non-array value assigned" do
    a = @subject.new([1, 2, 3, 4, 5])
    (a[2..4] = 10).should == 10
    (a.[]=(2..4, 10)).should == 10
  end

  it "returns array if array assigned" do
    a = @subject.new([1, 2, 3, 4, 5])
    (a[2..4] = [7, 8]).should == [7, 8]
    (a.[]=(2..4, [7, 8])).should == [7, 8]
  end

  it "just sets the section defined by range to nil even if the rhs is nil" do
    a = @subject.new([1, 2, 3, 4, 5])
    a[0..1] = nil
    a.should == [nil, 3, 4, 5]
  end

  it "just sets the section defined by range to nil if m and n < 0 and the rhs is nil" do
    a = @subject.new([1, 2, 3, 4, 5])
    a[-3..-2] = nil
    a.should == [1, 2, nil, 5]
  end

  it "replaces the section defined by range" do
    a = @subject.new([6, 5, 4, 3, 2, 1])
    a[1...2] = 9
    a[3..6] = [6, 6, 6]
    a.should == [6, 9, 4, 6, 6, 6]
  end

  it "replaces the section if m and n < 0" do
    a = @subject.new([1, 2, 3, 4, 5])
    a[-3..-2] = [7, 8, 9]
    a.should == [1, 2, 7, 8, 9, 5]
  end

  it "replaces the section if m < 0 and n > 0" do
    a = @subject.new([1, 2, 3, 4, 5])
    a[-4..3] = [8]
    a.should == [1, 8, 5]
  end

  it "inserts the other section at m if m > n" do
    a = @subject.new([1, 2, 3, 4, 5])
    a[3..1] = [8]
    a.should == [1, 2, 3, 8, 4, 5]
  end

  it "inserts at the end if m > the array size" do
    a = @subject.new([1, 2, 3])
    a[3..3] = [4]
    a.should == [1, 2, 3, 4]
    a[5..7] = [6]
    a.should == [1, 2, 3, 4, nil, 6]
  end

  describe "Range subclasses" do
    before :each do
      @range_incl = CollectionSpecs::MyRange.new(1, 2)
      @range_excl = CollectionSpecs::MyRange.new(-3, -1, true)
    end

    it "accepts Range subclasses" do
      a = @subject.new([1, 2, 3, 4])

      a[@range_incl] = ["a", "b"]
      a.should == [1, "a", "b", 4]
      a[@range_excl] = ["A", "B"]
      a.should == [1, "A", "B", 4]
    end

    it "returns non-array value if non-array value assigned" do
      a = @subject.new([1, 2, 3, 4, 5])
      (a[@range_incl] = 10).should == 10
      (a.[]=(@range_incl, 10)).should == 10
    end

    it "returns array if array assigned" do
      a = @subject.new([1, 2, 3, 4, 5])
      (a[@range_incl] = [7, 8]).should == [7, 8]
      a.[]=(@range_incl, [7, 8]).should == [7, 8]
    end
  end

  # TODO : Make sure the the 2.6 version is passing
  ruby_version_is "2.6" do
    it "just sets the section defined by range to nil even if the rhs is nil" do
      a = @subject.new([1, 2, 3, 4, 5])
      a[eval("(2..)")] = nil
      a.should == [1, 2, nil]
    end

    it "just sets the section defined by range to nil if m and n < 0 and the rhs is nil" do
      a = @subject.new([1, 2, 3, 4, 5])
      a[eval("(-3..)")] = nil
      a.should == [1, 2, nil]
    end

    it "replaces the section defined by range" do
      a = @subject.new([6, 5, 4, 3, 2, 1])
      a[eval("(3...)")] = 9
      a.should == [6, 5, 4, 9]
      a[eval("(2..)")] = [7, 7, 7]
      a.should == [6, 5, 7, 7, 7]
    end

    it "replaces the section if m and n < 0" do
      a = @subject.new([1, 2, 3, 4, 5])
      a[eval("(-3..)")] = [7, 8, 9]
      a.should == [1, 2, 7, 8, 9]
    end

    it "inserts at the end if m > the array size" do
      a = @subject.new([1, 2, 3])
      a[eval("(3..)")] = [4]
      a.should == [1, 2, 3, 4]
      a[eval("(5..)")] = [6]
      a.should == [1, 2, 3, 4, nil, 6]
    end
  end
end

describe :collection_element_set_after_shift, shared: true do
  it "works for insertion" do
    a = @subject.new([1,2])
    a.shift
    a.shift
    a[0,0] = [3,4]
    a.should == [3,4]
  end
end


describe "Array#[]=" do
  before { @subject = Array }

  it_behaves_like :collection_element_set, :[]=
  it_behaves_like :collection_element_set_with_index, :[]=
  it_behaves_like :collection_element_set_with_index_count, :[]=
  it_behaves_like :collection_element_set_with_range, :[]=
  it_behaves_like :collection_element_set_after_shift, :[]=
end

describe "Collection#[]=" do
  before { @subject = Group }

  it_behaves_like :collection_element_set, :[]=
  it_behaves_like :collection_element_set_with_index, :[]=
  it_behaves_like :collection_element_set_with_index_count, :[]=
  it_behaves_like :collection_element_set_with_range, :[]=
  it_behaves_like :collection_element_set_after_shift, :[]=
end