class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :messages
  has_many :room_users
  has_many :rooms, through: :room_users
  
  has_many :friendships
  has_many :friends, -> { where(friendships: { status: :accepted }) }, through: :friendships, source: :friend
  
  has_many :pending_friendship, -> { where(stats: :pending) }, class_name: 'Friendship'
  has_many :pending_friends, through: :pending_friendships, source: :friend
  
  def accept_friend_request(friend)
    friendships.create(friend: friend, status: :pending)
  end
  
  def accept_friend_request(friend)
    friendship = pending_friendships.find_by(friend: friend)
    friendship.update(status: :accepted) if friendship
  end
  
  def friend_with?(user)
    friends.include?(user)
  end
end
