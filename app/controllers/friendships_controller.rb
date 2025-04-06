class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find(params[:friend_id])
    current_user.friendships.create(friend: friend, status: :pending)
    redirect_to users_path, notice: '申請を送りました'
  end

  def update
    friendship = Friendship.find(params[:id])
    friendship.update(status: :approved)
    redirect_to users_path, notice: '申請を承認しました'
  end
  
  def destroy
    friendship = Friendship.find(params[:id])
    friendship.destroy
    redirect_to users_path, notice: '申請を削除しました'
  end
end
