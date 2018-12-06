class UsersController < ApplicationController
  skip_before_action :login_required, only: :create

  def index
    @user = current_user
  end
  
  def login
  end

  def show
    if logged_in?
      @user = User.find_by(email: session[:email])
    else
      redirect_to new_user_url
    end
  end
  def new
    @user = User.new
  end
  def create
    @user = User.new(user_params)
    if @user.save
      session[:email] = @user.email
      redirect_to @user
    else
      redirect_to new_user_url
    end
  end
  def destroy
    session[:email] = nil
    redirect_to new_user_url
  end
  private
  def logged_in?
    session[:email]
  end
  def user_params
    params.require(:user).permit(:email)
  end
end
