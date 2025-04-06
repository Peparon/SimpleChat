class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    
    if current_user.already_sent_request_to?(@user) || current_user.friend_with?(@user)
      redirect_to user_path, alert: 'すでに申請済み、または友人です' and return
    end
    
    friendship = current_user.sent_friendships.build(friend: @user, status: pending)
    
    if friendship.save
      redirect_to user_apth, notice: '友人申請を送りました'
    else
      redirect_to root_path, aleat: '申請に失敗しました'
    end
  end

  def update
    friendship = current_user.received_friendships.find(params[:id])
    
    if friendship.update(status: :accepted)
      redirect_to users_path, notice: '友人申請を承認しました'
    else
      redirect_to users_path, notice: '承認に失敗しました'
    end
  end
  
  def destroy
    friendship = Friendship.find(params[:id])
    
    if friendship.destroy
      redirect_to users_path, notice: '友人を解除しました'
    else
      redirect_to users_path, notice: '解除に失敗しました'
  end
end
