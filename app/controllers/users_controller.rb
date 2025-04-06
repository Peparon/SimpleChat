class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @users = User.where.not(id: current_user.id)
  end
  
  def update
    @uesr = crrent_user
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "プロフィールを更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end
end
