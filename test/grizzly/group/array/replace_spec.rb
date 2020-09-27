require_relative '../../../spec_helper'
require_relative 'fixtures/classes'
require_relative 'shared/replace'

describe "Array#replace" do
  before { @subject = Array }

  it_behaves_like :array_replace, :replace
end

describe "Collection#replace" do
  before { @subject = Group }

  it_behaves_like :array_replace, :replace
end
