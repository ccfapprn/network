class MailerController < ApplicationController
  before_action :authenticate_user!

  def confirm_alt_email
    @token = params[:token]
    @user = current_user
    @success = current_user.confirm_alt_email @token
  end

  # for testing
  #def generate
  #  @token =  Digest::MD5.hexdigest rand.to_s
  #  @link = mailer_confirm_url(:token => @token)
  #  @user = current_user

    #UserMail.confirm_alt_email(@user,@link).deliver
  #end
end
