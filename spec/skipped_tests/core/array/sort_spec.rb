require_relative '../../spec_helper'

module ArraySpecs
  class UFOSceptic
    def <=>(other); raise "N-uh, UFO:s do not exist!"; end
  end
end

describe "Array#sort" do
  # core/array/sort_spec.rb:98
  it "completes when supplied a block that always returns the same result" do
    a = Grizzly::Group.new([2, 3, 5, 1, 4])
    a.sort {  1 }.should be_an_instance_of(Grizzly::Group)
    a.sort {  0 }.should be_an_instance_of(Grizzly::Group)
    a.sort { -1 }.should be_an_instance_of(Grizzly::Group)
  end

  # core/array/sort_spec.rb:167
  it "returns subclass instance on Array subclasses" do
    ary = MyGroup[1, 2, 3]
    ary.sort.should be_an_instance_of(MyGroup)
  end

  # TODO: Update tests with Array.new
  # core/array/sort_spec.rb:84
  it "does not call #<=> on contained objects when invoked with a block" do
    a = Grizzly::Group.new(25)
    (0...25).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    a.sort { -1 }.should be_an_instance_of(Grizzly::Group)
  end

  # TODO: Update tests with Array.new
  # core/array/sort_spec.rb:91
  it "does not call #<=> on elements when invoked with a block even if Array is large (Rubinius #412)" do
    a = Grizzly::Group.new(1500)
    (0...1500).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    a.sort { -1 }.should be_an_instance_of(Grizzly::Group)
  end
end

describe "Array#sort!" do
  # core/array/sort_spec.rb:229
  it "completes when supplied a block that always returns the same result" do
    a = Grizzly::Group.new([2, 3, 5, 1, 4])
    a.sort!{  1 }.should be_an_instance_of(Grizzly::Group)
    a.sort!{  0 }.should be_an_instance_of(Grizzly::Group)
    a.sort!{ -1 }.should be_an_instance_of(Grizzly::Group)
  end

  # TODO: Update tests with Array.new
  # core/array/sort_spec.rb:215
  it "does not call #<=> on contained objects when invoked with a block" do
    a = Grizzly::Group.new(25)
    (0...25).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    a.sort! { -1 }.should be_an_instance_of(Grizzly::Group)
  end

  # TODO: Update tests with Array.new
  # core/array/sort_spec.rb:222
  it "does not call #<=> on elements when invoked with a block even if Array is large (Rubinius #412)" do
    a = Grizzly::Group.new(1500)
    (0...1500).each {|i| a[i] = ArraySpecs::UFOSceptic.new }

    a.sort! { -1 }.should be_an_instance_of(Grizzly::Group)
  end
end