module OODTApplicationController
  extend ActiveSupport::Concern

  # NOTE: this had to be moved to application_controller for it to be overridable as expected
  # included do
  #   # before_action :redirect_to_pairing_if_user_not_paired #this gets skipped in a few controllers with skip_before_action
  # end

  module ClassMethods
  end


  def redirect_to_pairing_if_user_not_paired
    if current_user && (!current_user.paired_with_lcp || !current_user.oodt_baseline_survey_complete)
      redirect_to pairing_wizard_path
      return
    end
  end


end
