class AuthController < ApplicationController
  def google_login
    if user = authenticate_with_google
      session[:security_token] = user.security_token
      redirect_to root_path
    else
      redirect_to root_path, alert: "Sign in before continuing"
    end
  end

  def logout
    session[:security_token] = nil
    redirect_to root_path
  end

  private

  def authenticate_with_google
    if flash[:google_sign_in].present?
      if id_token = flash[:google_sign_in]["id_token"]
        identity = GoogleSignIn::Identity.new(id_token)
        user = WebUser.find_by(social_token: identity.user_id)
        if user.present?
          user.update(social_name: identity.name, social_img_url: identity.avatar_url)
        else
          security_token = SecureRandom.hex
          user = WebUser.create(
            social_email: identity.email_address,
            social_name: identity.name,
            social_token: identity.user_id,
            social_img_url: identity.avatar_url,
            social_type: "Google",
            source_ip: request.ip,
            security_token: security_token,
          )
        end
        user
      elsif error = flash[:google_sign_in][:error]
        Rails.logger.error "Google authentication error: #{error}"
        nil
      end
    else
      Rails.logger.error "No Google sign-in data found in flash"
      nil
    end
  end
end
