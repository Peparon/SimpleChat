class RoomsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @rooms = current_user.rooms
  end
  
  def show
    @room = Room.find(params[:id])
    if @room.users.include?(current_user)
      @messages = @room.messages.includes(:user)
      @message = Message.new
    else
      redirect_to root_path, alert: "アクセスできません"
    end
  end
  
  def create
    @room = Room.new
    if @room.save
      RoomUser.create(user_id: current_user.id, room_id: @room.id)
      RoomUser.create(user_id: params[:user_id], room_id: @room.id)
      redirect_to @room
    else
      redirect_to users_path, alert: "ルーム作成に失敗しました"
    end
  end
end
