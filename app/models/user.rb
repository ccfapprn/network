class User < ActiveRecord::Base
  has_merit

  rolify role_join_table_name: 'roles_users'


  include Rails.application.routes.url_helpers

  include Authority::UserAbilities
  include Authority::Abilities

  # Enable User Connection to External API Accounts
  include ExternalAccounts

  self.authorizer_name = "UserAuthorizer"

  after_create :create_social_profile
  after_create :grant_first_survey_badge

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise_params = [ :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :lockable ]
  if Figaro.env.devise_confirmable == "true"
    devise_params << :confirmable
  end
  devise *devise_params


  # Model Validation
  #validates_presence_of :first_name, :last_name, :zip_code, :year_of_birth
  validates_numericality_of :year_of_birth, allow_nil: true, only_integer: true, less_than_or_equal_to: -> (user){ Date.today.year - 18 }, greater_than_or_equal_to: -> (user){ 1900 }

  # Model Relationships
  has_many :answer_sessions
  has_many :answers
  has_many :votes
  has_one :social_profile
  has_many :posts
  has_many :research_topics
  has_many :check_in_responses

  # Named Scopes
  default_scope { includes(:external_account) }

  scope :search_by_email, ->(terms) { where("LOWER(#{self.table_name}.email) LIKE ?", terms.to_s.downcase.gsub(/^| |$/, '%')) }


  # STUBS # TODO # TO IMPLEMENT
  scope :social, -> { where("1=1") } #TODO MUST DEFINE SOCIAL USERS #FIXME

  #alias
  def check_ins
    check_in_responses
  end

  def latest_check_in
    check_in_responses.last
  end

  def latest_check_in_complete
    check_in_responses.reverse.each do |resp|
      if resp.complete?
        return resp
      end
    end
   return nil
  end

  def latest_routine
    if external_account.user_routine
      external_account.user_routine.first
    else
      nil
    end
  end

  def latest_sleep
    if external_account.user_sleep
      external_account.user_sleep.first
    else
      nil
    end
  end

  def chart_health
    chart_survey_data(check_ins) {|c| c.health_index}
  end

  def chart_disease
    chart_survey_data(check_ins) {|c| c.disease_index}
  end

  def chart_sleep
    chart_validic_data(external_account.user_sleep) {|c| c.sleep_hours}
    #external_account.user_sleep.each { |c| chart[c.updated_at.strftime('%Y-%m-%d')] = {date: c.updated_at, data: c.sleep_hours}}
  end

  def chart_steps
    chart_validic_data(external_account.user_routine) {|c| c.steps.to_i}
  end

  def chart_calories_out
    chart_validic_data(external_account.user_routine) {|c| c.calories_burned.to_i}
  end


  def chart_survey_data(arr)
    chart = {}
    arr.each { |a| chart[a.updated_at.strftime('%Y-%m-%d')] = yield(a) }
    chart
  end

  def chart_validic_data(arr)
    chart = {}
    arr.each { |a| chart[a.timestamp_date.strftime('%Y-%m-%d')] = yield(a) }
    chart
  end

  def visible_to_community?
    social_profile.visible_to_community?
  end

  def community_name
    social_profile.community_name
  end


  def self.unique_cities_count
    self.count #FIXME #TODO #STUB
  end

  def self.health_data_streams_count
    0 #FIXME #TODO #STUB
  end


  ### BADGE - extra code for awarding badges here ###

  def badge_level(name)
    these_badges = self.badges.find_all { |b| b.name == name }
    if these_badges.any?
      these_badges.sort_by { |b| b.level }.last.level
    else
      0
    end
  end


  # CHECK IN BADGES
  def grant_first_survey_badge
    badge = Merit::Badge.find { |b| b.name == "survey_responder" && b.level == 1}.first
    add_badge(badge.id)
  end

  def update_check_in_badges
    next_checkin_level = badge_level("checkin") + 1
    checkin_quota = { 1=>1, 2=>3, 3=>5, 4=>10, 5=>20, 6=>30 }[next_checkin_level]

    grant_checkin_badge_on(next_checkin_level,checkin_quota)
  end


  def grant_checkin_badge_on(level, quota)
    return unless quota

    total_checkins = answer_sessions.select { |as| as.completed? }.count

    if total_checkins >= quota
      badge = Merit::Badge.find { |b| b.name == "checkin" && b.level == level}.first
      add_badge(badge.id)
    end
  end



  # SURVEY RESPONDER BADGES
  def update_survey_badges(num_surveys_completed)
    max_badge_level = 5 # FRAGILE: this needs to match to the highest level badge in merit.rb

    survey_badge_level_due = [num_surveys_completed, max_badge_level].min
    survey_badge_level_current = badge_level('survey_responder')

    if survey_badge_level_due > survey_badge_level_current
      badges_due = Merit::Badge.find { |b| b.name == 'survey_responder' && (b.level > survey_badge_level_current) && (b.level <= survey_badge_level_due) }

      badges_due.each do |badge|
        self.add_badge(badge.id)
      end
    end
    # if users have too many badges, or are missing badge levels, the clean_up_survey_badges which will be run on a cron should set things straight
  end

  def clean_up_survey_badges
    puts "Cleaning Survey Badges for User id##{self.id}"
    max_badge_level = 5 # FRAGILE: this needs to match to the highest level badge in merit.rb
    num_surveys_completed = get_num_surveys_completed
    num_surveys_completed = 2 if self.id == 36
    if num_surveys_completed == false
      puts " :::: Number of surveys completed could not be determined (OODT API call failed, perhaps because user hasn't been provisioned)"
      return
    else
      puts " >>>> User has completed #{num_surveys_completed} surveys"
    end

    survey_badge_level_due = [num_surveys_completed, max_badge_level].min
    received_survey_badges = self.badges.find_all { |b| b.name == 'survey_responder' }

    # Add Badges Due Not Received
    badges_due = Merit::Badge.find { |b| b.name == 'survey_responder' && (b.level <= survey_badge_level_due) }

    badges_due.each do |badge|
      if !received_survey_badges.include?(badge)
        puts " - Adding Badge #{badge.id}"
        self.add_badge(badge.id)
      end
    end

    # Remove Badges Not Due that have been received
    badges_not_due = Merit::Badge.find { |b| b.name == 'survey_responder' && (b.level > survey_badge_level_due) }

    badges_not_due.each do |badge|
      if received_survey_badges.include?(badge)
        puts " - Removing Badge #{badge.id}"
        self.rm_badge(badge.id)
      end
    end
  end







  def self.scoped_users(email=nil, role=nil)
    users = all

    users = users.search_by_email(email) if email.present?
    users = users.with_role(role) if role.present?

    users
  end

  def community_photo_url
    social_profile.community_photo_url
  end

  def private_photo_url
    social_profile.private_photo_url
  end

  def forem_name
    community_name
  end

  def to_s
    email
  end

  def revoke_consent
    update_attribute :accepted_consent_at, nil
    update_attribute :accepted_privacy_policy_at, nil
  end

  def signed_consent?
    # Local Consent Storage
    # self.accepted_consent_at.present?
    # OODT Consent Storage
    if OODT_ENABLED
      self.oodt_baseline_survey_complete
    else
      self.accepted_consent_at.present?
    end
  end

  def accepted_privacy_policy?
    self.accepted_privacy_policy_at.present?

  end

  def accepted_terms_conditions?
    self.accepted_terms_conditions_at.present?
  end

  def ready_for_research?
    accepted_privacy_policy? and signed_consent?
  end

  def forem_admin?
    self.has_role? :admin
  end

  def can_create_forem_topics?(forum)
    self.can?(:participate_in_social)
  end

  def can_reply_to_forem_topic?(topic)
    self.can?(:participate_in_social)
  end

  def can_edit_forem_posts?(forum)
    self.can?(:participate_in_social)
  end

  def can_destroy_forem_posts?(forum)
    self.can?(:participate_in_social)
  end


  def can_moderate_forem_forum?(forum)
    self.has_role? :forum_moderator or self.has_role? :admin
  end

  def is_owner?
    self.has_role? :owner
  end

  def is_admin?
    self.has_role? :admin or is_owner?
  end

  def is_moderator?
    self.has_role? :moderator or is_admin?
  end

  def incomplete_surveys
    QuestionFlow.incomplete(self)
  end

  def complete_surveys
    QuestionFlow.complete(self)
  end

  def unstarted_surveys
    QuestionFlow.unstarted(self)
  end

  def research_topics_with_vote
    ResearchTopic.voted_by(self)
  end

  def submitted_research_topics
    ResearchTopic.created_by(self)
  end

  def has_no_started_surveys?
    incomplete_surveys.blank? and complete_surveys.blank?
  end

  def share_research_topics?
    true
  end

  # Voting
  def vote_quota
    ENV["votes_per_user"].to_i + vote_modifier
  end

  def todays_votes
    votes.select{ |vote| vote.updated_at.today? and vote.rating != 0 and vote.research_topic_id.present? }
  end

  def total_votes
    votes.select{ |vote| vote.rating != 0 and vote.research_topic_id.present? }
  end

  # alias as per Sean's specs
  def votes_cast_count
    total_votes
  end

  def available_votes_percent
    (total_votes.length.to_f / vote_quota) * 100.0
  end

  def has_votes_remaining?(rating = 1)

    (total_votes.length < vote_quota) or (rating < 1)
  end

  def votes_remaining_count
     vote_quota - todays_votes.length
  end

  def topics_in_top_percentile(minimum_percentage)
    all = ResearchTopic.top_research_topics(minimum_percentage)
    my_rt_ids = research_topics.map{|rt| rt.id.to_s}
    mine = all.select{|result| my_rt_ids.include?(result["research_topic_id"])}

    mine
  end

  # use to set alt email (used for legacy partners) and send confirm (verification) email
  # returns false if alt_email already exists as primary or alt email
  # use alt_email_confirmed boolean to test that alt email is confirmed
  def set_alt_email(alt_email)
    # check email is already in use, primary or alt
    if User.find_by_email(alt_email) || User.where(["alt_email = ? and id <> ?",alt_email,self.id]).count > 0
      return false
    end

    self.alt_email = alt_email
    self.alt_email_confirmed = false
    token =  Digest::MD5.hexdigest rand.to_s
    self.alt_confirmation_token = token
    confirm_link = registrations_confirm_alt_email_url(:token => token)

    self.touch(:alt_confirmation_sent_at)
    self.save

    UserMail.confirm_alt_email(self,confirm_link).deliver
    return true
  end

  # check confirmation token recieved from email OK
  def self.confirm_alt_email(confirmation_token)

    #if self.alt_confirmation_token == confirmation_token
    #  self.touch(:alt_confirmed_at)
    #  self.alt_email_confirmed = true
    #  self.save
    #  return true
    #end
    #return false

    u = self.find_by_alt_confirmation_token(confirmation_token)
    if u
      u.touch(:alt_confirmed_at)
      u.alt_email_confirmed = true
      u.save
      return true
    else
      return false
    end
  end

end
