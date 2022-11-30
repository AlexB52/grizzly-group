require_relative '../../spec_helper'

describe "Array#sort_by!" do
  # core/array/sort_by_spec.rb:16
  it "completes when supplied a block that always returns the same result" do
    a = Grizzly::Group.new([2, 3, 5, 1, 4])
    a.sort_by!{  1 }
    a.should be_an_instance_of(Grizzly::Group)
    a.sort_by!{  0 }
    a.should be_an_instance_of(Grizzly::Group)
    a.sort_by!{ -1 }
    a.should be_an_instance_of(Grizzly::Group)
  end
end
