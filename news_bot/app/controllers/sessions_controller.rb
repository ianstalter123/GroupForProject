class SessionsController < ApplicationController
  def login
  end

  def signup
  	@user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_articles_path(@user), flash: {success: "Created!"}
    else
      redirect_to signup_path, flash: {error: @user.errors.full_messages}
	end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to login_path
  end


  private
  def user_params
    params.require(:user).permit(:email, :password)
  end

end



