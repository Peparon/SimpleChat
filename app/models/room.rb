class Room < ApplicationRecord
  has_many :room_users
  has_many :users, through: :room_users
  has_many :messagess
  
  def other_user(current_user)
    users.where.not(id: current_user.id).first
  end
end
