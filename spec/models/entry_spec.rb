require 'rails_helper'

describe Entry, :type => :model do
  it "has a valid factory" do
    expect(create(:entry)).to be_valid
  end
  
  it "is invalid without a word" do
    expect(build(:entry, word: nil)).to_not be_valid
  end
  
  it "does not allow duplicate words" do
    entry = create(:entry)
    expect(build(:entry, word: entry.word)).to_not be_valid
  end
  
  it "has many definitions" do
    should have_many(:definitions)
  end
end
