class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def search
    if params[:search_id].present?
      @friend = User.find_by(id: params[:search_id])
    end
    render "homes/home"
  end

  # def index
  #   @approved_friends = current_user.friendships.where(status: :approved).map(&:friend)
  #   @pending_friends = current_user.friendships.where(status: :peding).map(&:friend)
  # end

  # def create
  #   friend = User.find(params[:friend_id])
  #   current_user.friendships.create(friend: friend)
  #   redirect_to user_path, notice: "申請を送りました"
  # end

  # def update
  #   friendship = Friendship.find(params[:id])
  #   friendship.update(status: :approved)
  #   redirect_to users_path, notice: '申請を承認しました'
  # end

  # def destroy
  #   friendship = Friendship.find(params[:id])
  #   friendship.destroy
  #   redirect_to users_path, notice: '申請を削除しました'
  # end
end
