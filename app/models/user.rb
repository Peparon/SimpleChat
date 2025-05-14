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
  # after_create :create_sample_chat_data

  def approved_friends
    friends.merge(Friendship.where(status: 'approved')) + inverse_friends.merge(Friendship.where(status: 'approved'))
  end

  def room_with(other_user)
    Room.joins(:room_users).where(room_users: { user_id: [self.id, other.id] }).group('rooms.id').having('COUNT(DISTINCT room_users.user_id) = 2').first
  end

  private

  def generate_unique_friend_id
    loop do
      self.friend_id = SecureRandom.alphanumeric(8)
      break unless User.exists?(friend_id: friend_id)
    end
  end

  # サンプルチャット機能一旦保留
  # def create_sample_chat_data
  #   sample = User.find_by(email: 'sample@sample.com')
  #   return if sample.nil? || sample == self

  #   Friendship.find_or_create_by(user: self, friend: sample) { |f| f.status = :approved }
  #   Friendship.find_or_create_by(user: sample, friend: self) { |f| f.status = :approved }

  #   existing_room = Room.joins(:room_users)
  #                       .where(room_users: { user_id: [self.id, sample.id] })
  #                       .group('rooms.id')
  #                       .having('COUNT(DISTINCT room_users.user_id) = 2')
  #                       .first

  #   room = existing_room || Room.create!
  #   RoomUser.find_or_create_by(user: self, room: room)
  #   RoomUser.find_or_create_by(user: sample, room: room)

  #   if room.messages.empty?
  #     Message.create!(
  #       room: room,
  #       user: sample,
  #       content: 'SimpleChatへようこそ！友人IDで友人を検索して、チャットを始めましょう！'
  #     )
  #   end
  # end
end