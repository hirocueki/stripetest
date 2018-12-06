class SessionsController < ApplicationController
  skip_before_action :login_required
  def new
  end

  def create
    user = User.find_by(email: session_params[:email])

    if user
      session[:email] = user.email
      redirect_to user
    else
      redirect_to new_user_url
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: 'ログアウトしました。'
  end

  private

  def session_params
    params.require(:session).permit(:email)
  end
end
