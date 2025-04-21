class Room < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  has_many :messages, dependent: :destroy

  def self.find_or_create_by_users(user1, user2)
    room = Room.find_by(sender: user1, receiver: user2) || Room.find_by(sender: user2, receiver: user1)
    room || Room.create(sender: user1, receiver: user2)
  end

  def partner_of(user)
    sender == user ? receiver : sender
  end
end
