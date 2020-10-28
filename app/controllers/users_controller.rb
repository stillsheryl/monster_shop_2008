class UsersController < ApplicationController
  def new
    @form_info = user_params
  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:success] = "You are now registered and logged in."
      redirect_to '/profile'
    else
      flash[:errors] = user.errors.full_messages.uniq.to_sentence
      # if flash[:notice].include?('Email has already been taken')
      #   user.update(email: nil)
      # render :new
      redirect_to '/register'
    end
  end

  def show

  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password)
  end
end
