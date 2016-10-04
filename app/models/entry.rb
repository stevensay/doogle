class Entry < ActiveRecord::Base
  has_many :definitions, dependent: :destroy
  validates :word, presence: true, uniqueness: { case_sensitive: true }
end
