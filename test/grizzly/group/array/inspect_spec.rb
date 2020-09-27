require_relative '../../../spec_helper'
require_relative 'shared/inspect'


describe "Array#inspect" do
  before { @subject = Array }

  it_behaves_like :array_inspect, :inspect
end

describe "Collection#inspect" do
  before { @subject = Group }

  it_behaves_like :array_inspect, :inspect
end
