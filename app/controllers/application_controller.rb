# frozen_string_literal: true
class ApplicationController < ActionController::Base
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
