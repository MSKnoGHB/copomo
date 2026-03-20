class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:top, :about]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    public_user_path(resource)
  end

  def after_sign_out_path_for(resource)
    public_root_path
  end

  #他ユーザ操作禁止

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to public_user_path(current_user)
    end
  end

  def authorize_owner(resource)
    unless resource.user_id == current_user.id
      redirect_to public_user_path(current_user)
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :name])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:email])
  end

end
