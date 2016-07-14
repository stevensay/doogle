require 'rails_helper'

describe Definition, :type => :model do
  it "has a valid factory" do
    expect(create(:definition)).to be_valid
  end
  
  it "is invalid without a text" do
    expect(build(:definition, text: nil)).to_not be_valid
  end

  it "belongs to a word entry" do
    should belong_to(:entry)
  end
end
