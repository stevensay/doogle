class Definition < ActiveRecord::Base
  belongs_to :entry
  validates :text, presence: true
end
