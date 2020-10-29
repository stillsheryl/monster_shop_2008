class UsersController < ApplicationController
  def new

  end

  def create
    user = User.new(user_params)
    @params = user_params
    if user.save
      session[:user_id] = user.id
      flash[:success] = "You are now registered and logged in."
      redirect_to '/profile'
    else
      flash[:errors] = user.errors.full_messages.uniq.to_sentence
      render :new
    end
  end

  def show
    @user = User.find(session[:user_id])
  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
