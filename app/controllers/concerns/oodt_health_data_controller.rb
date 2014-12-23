module OODTHealthDataController
  extend ActiveSupport::Concern


  included do
      after_action :send_check_in_data_to_oodt_if_complete, :only => [:check_in]
  end



  private

  def send_check_in_data_to_oodt_if_complete
    if current_user && @answer_session.completed?
      current_user.send_check_in_data_to_oodt
    end
  end

end
