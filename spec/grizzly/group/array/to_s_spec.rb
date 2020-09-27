require_relative '../../../spec_helper'
require_relative 'shared/inspect'


describe "Array#to_s" do
  before { @subject = Array }

  it_behaves_like :array_inspect, :to_s
end

describe "Collection#to_s" do
  before { @subject = Group }

  it_behaves_like :array_inspect, :to_s
end
