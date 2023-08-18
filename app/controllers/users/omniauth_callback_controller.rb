class Users::OmniauthCallbackController < Devise::OmniauthCallbacksController
  def telegram
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Telegram") if is_navigational_format?
      redirect_to root_url
    else
      session["devise.telegram_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
      redirect_to new_user_registration_url
    end
  end
end
