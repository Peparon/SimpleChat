class RoomsController < ApplicationController
  before_action :authenticate_user!

  def index
    @rooms = Room.where("sender_id = ? OR receiver_id = ?", current_user.id, current_user.id)
  end

  def show
    @room = Room.find(params[:id])
    if [@room.sender, @room.receiver].include?(current_user)
      @partner = @room.partner_of(current_user)
      @messages = @room.messages.includes(:user)
      @message = Message.new
    else
      redirect_to root_path, alert: "アクセスできません"
    end
  end

  def create
    other_user = User.find(params[:user_id])
    @room = Room.find_or_create_by_users(current_user, other_user)

    unless current_user.friends.include?(other_user) || current_user.inverse_friends.include?(other_user)
      Friendship.create(user: current_user, friend: other_user, status: 'approved')
    end

    redirect_to room_path(@room)
  end
end
