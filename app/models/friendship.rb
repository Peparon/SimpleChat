class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :room
  
  # enum status: { pending: 0, accepted: 1, rejected: 2 }
  
  validates :content, presence: true
end
