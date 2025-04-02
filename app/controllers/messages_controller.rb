class MessagesController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @room = Room.find(params[:room_id])
    @messages = @room.messages.includes(:user)
  end
  
  def create
    @message = current_user.messages.new(message_params)
    if @message.save
      redirect_to room_path(@message.room)
    else
      render "rooms/show", status: :unprocessable_entity
    end
  end
  
  private
  
  def message_params
    params.require(:message).permit(:content, :room_id)
  end
  
end
