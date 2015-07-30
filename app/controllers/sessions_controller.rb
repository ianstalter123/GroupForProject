class SessionsController < ApplicationController

  def login

  end

  def signup
  	@user = User.new
  end

  def create
    @user = User.create user_params
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_articles_path(@user), flash: {success: "Created!"}
    else
      redirect_to signup_path, flash: {error: @user.errors.full_messages}
	end
  end

  def attempt_login
    if params[:email].present? && params[:password].present?
      @found_user = User.find_by_email params[:email]
      if @found_user && @found_user.authenticate(params[:password])
        session[:user_id] = @found_user.id
        redirect_to user_articles_path(@found_user)
      else
        flash[:alert] = "username / password combination is invalid"
        redirect_to login_path(@user)
      end
    else
      flash[:alert] = "please enter username and password"
      redirect_to login_path
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to login_path
  end


  private
  def user_params
    params.require(:user).permit(:email, :password, :password_digest)
  end

end