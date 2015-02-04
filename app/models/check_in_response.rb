class CheckInResponse < ActiveRecord::Base
  belongs_to :check_in_survey
  belongs_to :user

  validates_presence_of :check_in_survey
  validates_presence_of :user

  delegate :question, :questions, :questions_count, :question_titles, :to => :check_in_survey

  default_scope { includes(:check_in_survey) }




  def summary
    Hash[question_titles.zip(answers)]
  end

  def answers
    result = []
    1.upto(questions_count) { |i| result << answer(i) }
    result
  end

  def answer(n)
    unless question(n)['answer_type'] == :option
      answer_in_code(n)
    else
      answer_option_chosen(n)
    end
  end



  def answer_option_chosen(n)
    question(n)['answer_options'][answer_in_code(n)]
  end

  def answer_in_code(n)
    send "answer_#{n}"
  end


  # def method_missing(method, *args)
  #   return check_in_survey.send(method, *args) if check_in_survey && check_in_survey.respond_to?(method)
  #   super
  # end

end
