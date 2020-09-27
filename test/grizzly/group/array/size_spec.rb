require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/length'

describe "Array#size" do
  before { @subject = Array }

  it_behaves_like :array_length, :size
end

describe "Collection#size" do
  before { @subject = Group }

  it_behaves_like :array_length, :size
end
