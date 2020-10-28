class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "You are now logged in."
      if @user.user?
        redirect_to '/profile'
      elsif @user.merchant?
        redirect_to '/merchant'
      elsif @user.admin?
        redirect_to '/admin'
      else
        redirect_to '/login'
      end
    else
      flash[:errors] = 'Incorrect credentials, please try again.'
      redirect_to '/login'
    end
  end
end
