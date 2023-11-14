class Api::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:confirm_email]
  include ErrorHandling::RescueFrom
  def confirm_email
    email = confirm_email_params[:email]
    return render json: { error: 'The email is required.' }, status: :bad_request if email.blank?
    return render json: { error: 'The email format is invalid.' }, status: :bad_request unless email =~ URI::MailTo::EMAIL_REGEXP
    begin
      user = UserEmailConfirmationService.new(email).call
      return render json: { error: 'User not found' }, status: :not_found if user.nil?
      render json: { status: 200, user: { id: user.id, email: user.email } }, status: :ok
    rescue => e
      handle_error(e)
    end
  end
  private
  def confirm_email_params
    params.require(:user).permit(:email)
  end
end
