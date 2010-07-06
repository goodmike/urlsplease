require 'spec_helper'

describe Tag do
  it "is invalid without contents" do
    Tag.new().should_not be_valid
  end
end
