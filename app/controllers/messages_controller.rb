class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:room_id])

    unless @room.users.include?(current_user)
      redirect_to root_path, alert: '不正なアクセスです' and return
    end
    @message = @room.messages.new(message_params)
    @message.user = current_user
    if @message.save
      redirect_to room_path(@room)
    else
      @messages = @room.messages.includes(:user)
      flash.now[:alert] = 'メッセージを送信できませんでした'
      render 'rooms/show'
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

end
