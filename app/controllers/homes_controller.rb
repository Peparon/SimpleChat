class HomesController < ApplicationController

  def top
    redirect_to home_path if user_signed_in?
  end

  def home
    if params[:mode] == "friends"
      @friends = current_user.friends
    end
  end
end
