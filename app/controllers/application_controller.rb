class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception
  # before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected

  def user_not_authorized
    flash[:warning] = 'You are not authorized to perform this action.'
    redirect_back(fallback_location: root_path)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

  def after_sign_in_path_for(_resource)
    # dashboard_path
    root_path
  end

  def authorize_resource
    authorize params[:controller].classify.constantize
  end
end
