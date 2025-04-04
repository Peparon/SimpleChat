class RoomsController <
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id)
  end

  def create
    @user = User.find(params[:id])
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.includes(:user)
    @messge = Message.new
  end
end
