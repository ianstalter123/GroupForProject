class ResetsController < ApplicationController

  def new
  end
  def create
    user = User.find_by(email: params[:email])
    if user
      user.generate_password_reset_token!
      Reset.password_reset(user).deliver_now
      redirect_to login_path, notice: "Email sent"
    else
      flash.now[:alert] = "Email not found"
      render :new
    end
  end
end
