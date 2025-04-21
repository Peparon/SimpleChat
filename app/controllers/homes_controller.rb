class HomesController < ApplicationController

  def top
    redirect_to home_path if user_signed_in?
  end

  def home
    if params[:mode] == "friends"
      @friends = current_user.approved_friends
      @show_friend_search = params[:submode] == "search"

      # 検索
      if @show_friend_search && params[:friend_id].present?
        @friend = User.find_by(friend_id: params[:friend_id])
      end

      if params[:selected_friend_id].present?
        @selected_friend = User.find_by(id: params[:selected_friend_id])

        if @selected_friend
          unless Friendship.exists?(user_id: current_user.id, friend_id: @selected_friend.id)
            Friendship.create(user_id: current_user.id, friend_id: @selected_friend.id, status: "approver")
            Friendship.create(user_id: @selected_friend.id, friend_id: current_user.id, status: "approver")
          end
          # ルーム取得作成
          @room = Room.find_by(sender_id: current_user.id, receiver_id: @selected_friend.id) || Room.find_by(sender_id: @selected_friend.id, receiver_id: current_user.id)
          unless @room
            @room = Room.create(sender_id: current_user.id, receiver_id: @selected_friend.id)
          end
          # 準備
          @messages = @room.messages.order(created_at: :asc)
          @message = Message.new
        end
      end

    elsif params[:mode] == "setting"
      @user = current_user
    end
  end
end
