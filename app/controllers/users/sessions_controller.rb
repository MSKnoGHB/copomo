# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  before_action :user_state, only: [:create]


  private

  def user_state
    user = User.find_by(name: params[:user][:name])

    return if user.nil?
    return unless user.valid_password?(params[:user][:password])

    unless user.is_active
      redirect_to new_user_registration_path
    end
  end

end
