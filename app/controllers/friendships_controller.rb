class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find(params[:friend_id])
    current_user.friendships.create(friend: friend, status: :pending)
    redirect_to root_path, notice: '友人申請を送りました!'
  end

  def update
    friendship = Friendship.find(params[:id])
    if params[:status] == "accepted"
      friendship.update(status: :accepted)
      redirect_to root_path, notice: '友人を承認しました！'
    elsif params[:status] == "rejected"
      friendship.update(status: :rejected)
      redirect_to root_path, alert: '友人申請を拒否しました。'
    end
  end

  def destroy
    friendship = Friendship.find(params[:id])
    friendship.destroy
    redirect_to root_path, notice: '友人を削除しました。'
  end
end
