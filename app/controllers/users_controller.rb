class UsersController < ApplicationController
  before_action :set_and_authorize_resource, only: %i[show edit update destroy]
  before_action :authorize_resource, except: %i[show edit update destroy]
  after_action :verify_authorized

  def index
    authorize @users = User.all
  end

  def show; end

  def update
    if @user.update_attributes(resource_params)
      redirect_to users_path, notice: 'User updated'
    else
      redirect_to users_path, alert: 'Unable to update user'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, notice: 'User deleted.'
  end

  def get
    @users = User.find(params[:ids])
    case params[:option]
    when 'signin_count'
      @users = @users.map { |e| {username: e.username, signin: e.sign_in_count} }
    end
    respond_to do |format|
      format.json { render json: @users }
    end
  end

  private

  def set_and_authorize_resource
    authorize @user = User.find(params[:id])
  end

  def resource_params
    params.require(:user).permit(:role, :email, :username, :first_name, :last_name, :display_name)
  end
end
