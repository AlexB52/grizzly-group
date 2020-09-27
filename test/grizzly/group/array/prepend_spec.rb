require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/unshift'

describe "Array#prepend" do
  before { @subject = Array }

  it_behaves_like :array_unshift, :prepend
end

describe "Collection#prepend" do
  before { @subject = Group }

  it_behaves_like :array_unshift, :prepend
end
