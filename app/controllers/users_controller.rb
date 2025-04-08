class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]
  
  def index
    @users = User.where.not(id: current_user.id)
  end
  
  def show
    @friendship = Friendship.find_by(user_id: current_user.id, friend_id: @user.id) || Friendship.find_by(user_id: @user.id, friend_id: current_user.id)
  end
  
  def edit
    unless @user == current_user
      redirect_to root_path, alert: "他人のプロフィールは編集できません"
    end
  end
  
  def update
    if @user == current_user
      if @user.update(user_params)
        redirect_to @user, notice: "プロフィールを更新しました"
      else
        render :edit, alert: "更新に失敗しました"
      end
    else
      redirect_to root_path, alert: "他人のプロフィールは編集できません"
    end
  end
  
  private
  
  def set_user
    @user = User.find(params[:id])
  end
  
  def user_params
    params.require(:user).permit(:name, :email)
  end
end
