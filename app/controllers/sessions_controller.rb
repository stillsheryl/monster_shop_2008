class SessionsController < ApplicationController

  def new
    if current_admin?
      flash[:message] = 'You are already logged in.'
      redirect_to '/admin'
    elsif current_merchant?
      flash[:message] = 'You are already logged in.'
      redirect_to '/merchant'
    elsif current_user
      flash[:message] = 'You are already logged in.'
      redirect_to '/profile'
    end
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
      end
    else
      flash[:errors] = 'Incorrect credentials, please try again.'
      redirect_to '/login'
    end
  end

  def destroy
    session.destroy
    flash[:message] = 'You are now logged out.'
    redirect_to '/home'
  end
end
