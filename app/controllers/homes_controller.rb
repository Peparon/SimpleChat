class HomesController < ApplicationController

  def top
    redirect_to home_path if user_signed_in?
  end

  def home
    clean_old_rooms

    if params[:mode] == "friends"
      @friends = current_user.approved_friends
      @show_friend_search = params[:submode] == "search"

      # 検索
      if @show_friend_search && params[:friend_id].present?
        @friend = User.find_by(friend_id: params[:friend_id])
      end

      # if params[:selected_friend_id].present?
      #   @selected_friend = User.find_by(id: params[:selected_friend_id])
      # end

      if params[:selected_friend_id].present?
        session[:selected_friend_id] = params[:selected_friend_id]
      end

      if session[:selected_friend_id].present?
        @selected_friend = User.find_by(id: session[:selected_friend_id])
      end

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

    elsif params[:mode] == "setting"
      @user = current_user
    end

    @effect = params[:effect]
  end

  def clean_old_rooms
    Room.includes(:messages).find_each do |room|
      last_message = room.messages.order(created_at: :desc).first
      if last_message && last_message.created_at < 144.hours.ago
        puts "#{room.id}(#{last_message.created_at})"
        room.messages.destroy_all
        room.destroy
      end
    end
  end
end
