class SessionsController < Devise::SessionsController

  skip_before_action :redirect_to_pairing_if_user_not_paired
  after_action :sync_oodt_status, only: [:create]
  after_action :record_user_action, only: [:create]


  private

  def sync_oodt_status
    current_user.sync_oodt_status(return_url: pairing_wizard_url) if current_user
  end

  def record_user_action
    logger.info "LOGIN!!!!!!!!"
    if current_user
      ua = UserAction.new
      ua.user_id = current_user.id
      ua.action = 'login'
      ua.save
    end
  end

end