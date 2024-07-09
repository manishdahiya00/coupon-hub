class AuthController < ApplicationController
  def google_login
    if user = authenticate_with_google
      cookies.signed[:security_token] = session[:security_token]
      redirect_to root_path
    else
      redirect_to root_path, alert: "authentication_failed"
    end
  end

  def logout
    session[:security_token] = ""
    redirect_to root_path
  end

  private

  def authenticate_with_google
    if id_token = flash[:google_sign_in]["id_token"]
      user = WebUser.find_by(social_token: GoogleSignIn::Identity.new(id_token).user_id)
      if user.present?
        session[:security_token] = user.security_token
        return true
      else
        security_token = SecureRandom.hex
        @user = WebUser.new(social_email: GoogleSignIn::Identity.new(id_token).email_address, social_name: GoogleSignIn::Identity.new(id_token).name, social_token: GoogleSignIn::Identity.new(id_token).user_id, social_img_url: GoogleSignIn::Identity.new(id_token).avatar_url, social_type: "Google", source_ip: request.ip, security_token: security_token)
        if @user.save
          session[:security_token] = @user.security_token
          return true
        else
          return false
        end
      end
    elsif error = flash[:google_sign_in][:error]
      Rails.logger.error "Google authentication error: #{error}"
      nil
    end
  end
end
