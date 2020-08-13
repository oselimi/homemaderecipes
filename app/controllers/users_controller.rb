class UsersController < ApplicationController
  before_action :logged_in_user, except: [:show, :new, :create]
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to @user
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :handle_name, :email, :password, :password_confirmation)
  end
end
