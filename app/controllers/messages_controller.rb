class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.build(message_params)
    @message.user = current_user

    respond_to do |format|
      if @message.save
        format.js
      else
        format.js { render js: "alert('メッセージを送信できませんでした');" }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

end
