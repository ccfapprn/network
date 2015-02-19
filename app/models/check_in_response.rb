class CheckInResponse < ActiveRecord::Base
  belongs_to :check_in_survey
  belongs_to :user

  validates_presence_of :check_in_survey
  validates_presence_of :user

  delegate :title, :question, :questions, :questions_count, :question_type, :question_title, :question_titles, :to => :check_in_survey

  default_scope { includes(:check_in_survey).order(:updated_at) }

  after_initialize :set_survey_version_if_unset
  after_save :send_data_to_oodt

  def self.current_check_in(user)
    current_check_in = where(user: user.id, created_at: (Time.now - Figaro.env.check_in_frequency.to_i.hours)..Time.now ).order(created_at: :desc).first
    if !current_check_in
      current_check_in = user.check_in_responses.build
    end
    current_check_in
  end


  def set_survey_version_if_unset
    if user && !check_in_survey

      if user.has_ileostomy?
        self.check_in_survey = CheckInSurvey.find_by_version("IL1.0")
      else
        disease_type = user.get_disease_type

        if disease_type && disease_type == "Crohn's disease"
          self.check_in_survey = CheckInSurvey.find_by_version("CD1.0")
        else # they get the UC survey ---- disease_type && disease_type == "Ulcerative colitis"
          self.check_in_survey = CheckInSurvey.find_by_version("UC1.0")
        end

      end

    end
  end


  def summary
    Hash[question_titles.zip(answers_in_human)]
  end

  def answers_in_human
    result = []
    1.upto(questions_count) { |i| result << answer_in_human(i) }
    result
  end

  def answer_in_human(n)
    unless question(n)['answer_type'] == :option
      answer(n)
    else
      answer_option_chosen(n)
    end
  end

  def answer_type(n)
    question(n)['answer_type']
  end

  def answer_options(n)
    question(n)['answer_options']
  end

  def answer_option_chosen(n)
    question(n)['answer_options'][answer(n)]
  end

  def answer(n)
    send answer_method(n)
  end

  def answer_method(n)
    "answer_#{n}"
  end


  def last_question?(n)
    n == questions_count
  end

  def first_question?(n)
    n == 1
  end

  def complete?
    1.upto(questions_count) do |i| 
      if answer(i).nil?
        return false
      end
    end
    return true
  end

  def health_index
    if user && complete?
      summary['How are you feeling today?']
    else
      nil
    end
  end

  def disease_index
    if user && complete?
      if user.has_ileostomy?
        nil # no disease index available
      elsif check_in_survey.version == 'CD1.0'
        scdai
      else
        prucsi
      end
    else
      nil # unable to calc
    end
  end

  def scdai
    well_being = answer(2)
    pain = answer(3)
    stools = answer(4) < 30 ? answer(4) : 30

    idx = 44 + (2*(stools*7)) + (5*(pain*7)) + (7*(well_being*7))
    idx.round
  end

  def prucsi
    well_being = answer(1)
    bleeding = answer(2)
    stool_frequency = answer(3)

    idx = (0.7824 * stool_frequency) + (1.0925 * bleeding) + (1.4727 * well_being)
    idx.round
  end


  private

  def send_data_to_oodt
    user.send_check_in_data_to_oodt(to_oodt_format)
  end

  def to_oodt_format
    result = []
    1.upto(questions_count) { |n| result << [ question(n)['oodt_key'], answer(n) ] }

    final_result = Hash[result].merge("timestamp" => updated_at.strftime("%Y-%m-%dT%H:%M:%SZ")).reject { |k,v| k.nil? }
  end


end
