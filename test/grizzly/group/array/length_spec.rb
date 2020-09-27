require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/length'

describe "Array#length" do
  before { @subject = Array }

  it_behaves_like :array_length, :length
end

describe "Collection#length" do
  before { @subject = Group }

  it_behaves_like :array_length, :length
end
