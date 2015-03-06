class HealthDataController < ApplicationController
  before_action :authenticate_user!, :only => [:data_explore, :data_reports, :medications]
  before_action :set_active_top_nav_link_to_health_data
  before_action :check_in_setup
  before_action :med_list_setup

  layout "health_data"


  def index
  end


  def my_dashboard
    # @disease_activity_scores = {}
    # @disease_activity_result = {}

    # if (current_user && OODT_ENABLED)
    #   @disease_activity_result = current_user.get_disease_activity_scores
    #   if @disease_activity_result #API call was successful
    #     if @disease_activity_result['numScores'] > 0
    #       @disease_activity_scores = @disease_activity_result['scores']
    #     end
    #   end
    # end

    #@disease_activity_score = (current_user && OODT_ENABLED) ? current_user.get_disease_activity_score : {}

    if current_user
      @user_sleep = current_user.latest_sleep
      @user_routine = current_user.latest_routine
      #@health_today = current_user.latest_check_in_complete.health_index 
      #@disease_index = current_user.latest_check_in_complete.disease_index
      @check_in = current_user.latest_check_in_complete
      @synched = @user_sleep || @user_steps
    end
  end

 def my_health_measures
    @chart_urls = (current_user and OODT_ENABLED) ? current_user.get_chart_urls : {}
  end

  def my_connections
    if current_user
      if VALIDIC_ENABLED
        current_user.provision_if_unprovisioned if current_user
        @marketplace = current_user.get_validic_marketplace
      end
    end
  end

  def load_connections
  end


  private

  def check_in_setup
    @current_check_in = CheckInResponse.current_check_in(current_user) if current_user
  end


  def med_list_setup
    @med_list = (current_user and OODT_ENABLED) ? current_user.get_med_list : {}
  end


end