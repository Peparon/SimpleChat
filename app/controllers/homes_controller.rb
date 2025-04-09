class HomesController < ApplicationController
  
  def top
    redirect_to home_index_path if user_signed_in?
  end

  def index
  end
end
