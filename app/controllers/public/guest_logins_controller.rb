class Public::GuestLoginsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:guest_sign_in]

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to public_user_path(user), notice: "guestuserでログインしました。"
  end

end