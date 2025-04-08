class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:room_id])
    if @room.users.include?(current_user)
      @message = @room.messages.build(message_params)
      @message.user = current_user
      if @message.save
        redirect_to room_path(@room)
      else
        @messages = @room.messages.includes(:user)
        render "rooms/show"
      end
    else
      redirect_to root_path, alert: "アクセスできません"
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

end
