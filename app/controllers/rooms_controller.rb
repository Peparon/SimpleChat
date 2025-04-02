class RoomsController <
  before_action :authenticate_user!

  def index
    @rooms = Room.all
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.includes(:user)
    @messge = Message.new
  end
end
