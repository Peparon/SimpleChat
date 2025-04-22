class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friendships
  has_many :friends, through: :friendships

  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'
  has_many :inverse_friends, through: :inverse_friendships, source: :user

  has_many :messages
  has_many :room_users
  has_many :rooms, through: :room_users

  validates :name, presence: true, length: { maximum: 10 }

  before_create :generate_unique_friend_id

  def approved_friends
    friends.merge(Friendship.where(status: 'approved')) + inverse_friends.merge(Friendship.where(status: 'approved'))
  end

  private

  def generate_unique_friend_id
    loop do
      self.friend_id = SecureRandom.alphanumeric(8)
      break unless User.exists?(friend_id: friend_id)
    end
  end

end