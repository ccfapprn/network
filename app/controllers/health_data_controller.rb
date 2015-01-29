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

    award_check_in_badges if @answer_session.completed?
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

  def award_check_in_badges

    next_checkin_level = current_user.badge_level("checkin") +1
    checkin_quota = { 1=>1, 2=>3, 3=>5, 4=>10, 5=>20, 6=>30 }[next_checkin_level]


    grant_checkin_badge_on(next_checkin_level,checkin_quota)
    # grant_checkin_badge_on(2,3)
    # grant_checkin_badge_on(3,5)
    # grant_checkin_badge_on(4,10)
    # grant_checkin_badge_on(5,20)
    # grant_checkin_badge_on(6,30)
  end

  def grant_checkin_badge_on(level, quota)
    return unless quota

    total_checkins = @answer_session.user.answer_sessions.select { |as| as.completed? }.count

    if total_checkins >= quota #note, this will count all answer sessions, not just health checkin types
      badge = Merit::Badge.find { |b| b.name == "checkin" && b.level == level}.first
      current_user.add_badge(badge.id)
    end
  end

  def med_list_setup
    @med_list = (current_user and OODT_ENABLED) ? current_user.get_med_list : {}
  end


end
