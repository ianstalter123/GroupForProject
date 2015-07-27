class UsersController < ApplicationController
	
	# TODO create these methods in the user model and below
	# before_action :prevent_login_signup, only: [:new]
 #  before_action :confirm_logged_in, except: [:new, :create]
 #  before_action :ensure_correct_user, only: [:edit, :update]

  def index
		@user = User.find_by(session[:user_id])
  	# @articles = @user.includes(:articles)
  end

  def show
  end

  def new
  end

  def create
  	
  end

  def edit
  end

  def update
  	
  end
end
