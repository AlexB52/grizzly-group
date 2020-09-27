require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/unshift'

describe "Array#unshift" do
  before { @subject = Array }

  it_behaves_like :array_unshift, :unshift
end

describe "Collection#unshift" do
  before { @subject = Group }

  it_behaves_like :array_unshift, :unshift
end
