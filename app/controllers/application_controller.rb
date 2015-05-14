class ApplicationController < ActionController::Base

  # Add theme folder to view path
  self.view_paths.unshift(*Rails.root.join('app', 'views', ENV['website_code_name'])) if ENV['website_code_name']

  before_action :redirect_to_pairing_if_user_not_paired

  def forem_user
    current_user
  end
  helper_method :forem_user

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception



  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || health_data_path
  end

  # Send 'em back where they came from with a slap on the wrist
  def authority_forbidden(error)
    Authority.logger.warn(error.message)
    redirect_to request.referrer.presence || root_path, :alert => "Sorry! You attempted to visit a page you do not have access to. If you believe this message to be unjustified, please contact us at <#{Figaro.env.website_support_email}>."
  end



  def set_active_top_nav_link_to_research
    @active_top_nav_link = :research
  end

  def set_active_top_nav_link_to_health_data
    @active_top_nav_link = :health_data
  end

  def set_active_top_nav_link_to_members
    @active_top_nav_link = :members
  end

  def set_active_top_nav_link_to_blog
    @active_top_nav_link = :blog
  end

  def no_layout
    render layout: false
  end


  private

  def redirect_to_pairing_if_user_not_paired
    if current_user && (!current_user.paired_with_lcp || !current_user.oodt_baseline_survey_complete)
      redirect_to pairing_wizard_path
      return
    end
  end


end
