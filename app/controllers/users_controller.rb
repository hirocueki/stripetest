class UsersController < ApplicationController
  skip_before_action :login_required, only: %i(index create new)

  def index
    @customer_ids = Stripe::Customer.all.map{|customer|customer.id}
    @users = User.where(customer_id: @customer_ids)
  end
  
  def login
  end

  def show
    if logged_in?
      @user = User.find_by(email: session[:email])
      @plan = Stripe::Plan.retrieve("plan_E6q6YUSVspFYGv")
    else
      redirect_to new_user_url
    end
  end

  def subscription
    stripe_customer = Stripe::Customer.retrieve(@user.customer_id)
    stripe_customer.source = params[:stripeToken] # Stripe.jsで変換したトークンを渡すだけ
    stripe_customer.save

    stripe_subscription = Stripe::Subscription.retrieve(@user.stripe_subscription_id)
    stripe_subscription.plan = Plan.find(params[:plan_id])
    stripe_subscription.save
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    customer = Stripe::Customer.create(
      "description": @user.name,
      "email": @user.email,
    )
    @user.customer_id = customer.id
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
    params.require(:user).permit(:name, :email)
  end
end
