class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find(params[:friend_id])
    current_user.send_friend_request(friend)
    redirect_to root_path, notice: '友人申請を送りました!'
  end

  def update
    friend = User.find(params[:id])
    current_user.accept_friend_request(friend)
    redirect_to root_path, notice: '友人を承認しました！'
  end

  def destroy
    friendship = Friendship.find(params[:id])
    friendship.destroy
    redirect_to root_path, notice: '友人を削除しました。'
  end
end
