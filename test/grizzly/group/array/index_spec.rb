require_relative '../../../spec_helper'
require_relative 'shared/index'

describe "Array#index" do
  before { @subject = Array }

  it_behaves_like :array_index, :index
end

describe "Collection#index" do
  before { @subject = Group }

  it_behaves_like :array_index, :index
end
