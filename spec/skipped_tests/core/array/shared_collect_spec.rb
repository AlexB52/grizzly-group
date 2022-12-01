require_relative '../../spec_helper'

# core/array/shared/collect.rb:11
describe "Array#map" do
  it "does not return subclass instance" do
    MyGroup[1, 2, 3].send(:map) { |x| x + 1 }.should be_an_instance_of(Array)
  end
end

describe "Array#collect" do
  it "does not return subclass instance" do
    MyGroup[1, 2, 3].send(:collect) { |x| x + 1 }.should be_an_instance_of(Array)
  end
end
