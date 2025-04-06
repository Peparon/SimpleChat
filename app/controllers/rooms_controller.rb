class RoomsController <
  before_action :authenticate_user!
  
  def index
    @rooms = current_user.rooms
  end
  
  def show
    @room = Room.find(params[:id])
    unless @room.users.include?(current_user)
      redirect_to root_path, alert: 'アクセスできません'
      return
    end
    @message = Message.new
    @messages = @room.messages.includes(:user)
    @friend = @room.other_user(current_user)
  end
  
  def create
    friend = User.find(params[:user_id])
    room = current_user.existing_room_with(friend)
    if room
      redirect_to room_path(room)
    else
      room = Room.create!
      room.room_users.create!(user: current_user)
      room.room_users.create!(user: friend)
      redirect_to room_path(room)
    end
  end
end
