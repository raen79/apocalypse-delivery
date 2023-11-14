# frozen_string_literal: true
class ApplicationController < ActionController::Base
  def confirm_email
    # Validate the email
    email = params[:email]
    if email.blank? || !(email =~ URI::MailTo::EMAIL_REGEXP)
      flash[:error] = "Invalid email address"
      return
    end
    # Send confirmation email
    confirmation_token = SecureRandom.urlsafe_base64
    user = User.find_by_email(email)
    if user
      user.update(confirmation_token: confirmation_token)
      ApplicationMailer.confirmation_email(user).deliver_now
      flash[:notice] = "Confirmation email has been sent. Please check your email."
    else
      flash[:error] = "User not found"
    end
    # Wait for user to click on the confirmation link
    # This will be handled in another action, e.g., UsersController#confirm_email
  end
  def create_user(username, password)
    # Validate input
    return unless username.present? && password.present?
    # Check if username is already taken
    user = User.find_by(username: username)
    return if user.present?
    # Encrypt password
    password_digest = BCrypt::Password.create(password)
    # Create new user
    new_user = User.create(username: username, password_digest: password_digest)
    # Return new user ID
    new_user.id
  end
end
