module OODTApplicationController
  extend ActiveSupport::Concern

  included do
    before_action :redirect_to_pairing_if_user_not_paired, except: [:pairing_wizard]
  end

  module ClassMethods

  end


  def redirect_to_pairing_if_user_not_paired
    if current_user && (!current_user.paired_with_lcp || !current_user.oodt_baseline_survey_complete)
      redirect_to pairing_wizard_path
      return
    end
  end


end
