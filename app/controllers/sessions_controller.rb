class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in(user)
      flash[:info] = "Welcome #{user.username}.."
      redirect_to user_path(user)
    else
      flash.now[:danger] = 'Invalid email/password'
      render :new
    end
  end

  def destroy
    log_out
    flash[:warning] = 'You are logged out now..'
    redirect_to root_path
  end
end
