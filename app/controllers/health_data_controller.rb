class HealthDataController < ApplicationController
  before_action :authenticate_user!, :only => [:data_explore, :data_reports, :medications]
  before_action :set_active_top_nav_link_to_health_data
  before_action :check_in_setup
  before_action :med_list_setup

  layout "health_data"

  def initialize
    include_plugins
    super
  end


  def index
    @disease_activity_scores = {}
    @disease_activity_result = {}

    if (current_user && OODT_ENABLED)
      @disease_activity_result = current_user.get_disease_activity_scores
      if @disease_activity_result #API call was successful
        if @disease_activity_result['numScores'] > 0
          @disease_activity_scores = @disease_activity_result['scores']
        end
      end
    end

    #@disease_activity_score = (current_user && OODT_ENABLED) ? current_user.get_disease_activity_score : {}
  end


  def my_dashboard
  end

  def my_health_measures
    @chart_urls = (current_user and OODT_ENABLED) ? current_user.get_chart_urls : {}
  end


  def submit_check_in
    params[:question_id]
    params[:value]
  end

  def check_in
    question = Question.find(params[:question_id])

    @answer = @answer_session.process_answer(question, params)

    render json: {answer: @answer, next_question_id: (@answer.next_question.id if @answer and @answer.next_question)}

    current_user.update_check_in_badges if @answer_session.completed?
  end


  private

  def check_in_setup
    if current_user
      @question_flow = current_user.get_checkin_flow
      @answer_session = AnswerSession.most_recent(@question_flow.id, current_user.id)

      if @answer_session.nil? or (@answer_session.completed? and (Time.zone.now - @answer_session.updated_at) >= Figaro.env.check_in_frequency.to_i * 3600) or params[:new_check_in]
        #raise StandardError
        @answer_session = AnswerSession.create(user_id: current_user.id, question_flow_id: @question_flow.id)
      end
    end
  end


  def include_plugins
    self.class.send(:include, OODTHealthDataController) if OODT_ENABLED
  end


  def med_list_setup
    @med_list = (current_user and OODT_ENABLED) ? current_user.get_med_list : {}
  end


end
