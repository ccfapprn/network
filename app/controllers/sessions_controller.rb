class SessionsController < Devise::SessionsController

  skip_before_action :redirect_to_pairing_if_user_not_paired
  after_action :sync_oodt_status, only: [:create]


  private

  def sync_oodt_status
    current_user.sync_oodt_status(return_url: pairing_wizard_url) if current_user
  end

end