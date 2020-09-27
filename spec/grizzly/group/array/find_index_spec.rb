require_relative '../../../spec_helper'
require_relative 'shared/index'

describe "Array#find_index" do
  before { @subject = Array }

  it_behaves_like :array_index, :find_index
end

describe "Collection#find_index" do
  before { @subject = Group }

  it_behaves_like :array_index, :find_index
end
