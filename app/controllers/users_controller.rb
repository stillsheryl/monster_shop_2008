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
    if current_user.nil?
      render file: "/public/404"
    else
      @user = User.find(session[:user_id])
    end
  end

  def edit

  end

  def update
    if user_params.to_h.values.any?('')
      flash.now[:error] = "No fields can be blank."
      render :edit
    elsif !current_user.authenticate(user_params[:password])
      flash.now[:error] = "Incorrect password."
      render :edit
    elsif current_user.email_exist?(user_params[:email])
      flash.now[:error] = "Email is already taken."
      render :edit
    else
      current_user.update(user_params)
      flash[:success] = "Profile information updated."
      redirect_to '/profile'
    end
  end

  def edit_password

  end

  def update_password
    current_user.update(user_params)
    flash[:success] = "Your password has been updated."
    redirect_to '/profile'
  end

  private
  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
