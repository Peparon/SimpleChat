class RoomsController <
  before_action :authenticate_user!

  def create
    existing_room = Room.joins(:room_users).where(room_users: { user_id: crrent_user.id })
                        .joins(:room_users).where(room_users: { user_id: params[:id] })
                        .first
    if existing_room
      redirect_to room_path(existing_room)
    else
      room = Room.create
      room.room_users.create(user_id: current_user.id)
      room.room_users.create(user_id: params[:user_id])
      redirect_to room_path(room)
    end
  end

  def show
    @room = Room.find(params[:id])
    unless @room.users.include?(current_user)
      redirect_to root_path, alert: 'アクセスできません'
    end
    @messages = @room.messages.includes(:user)
    @message = Message.new
  end
end
