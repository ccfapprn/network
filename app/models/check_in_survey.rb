class CheckInSurvey < ActiveRecord::Base
  has_many :check_in_responses
  validates_presence_of :version

  ## If you change the number of questions in the schema, update these:
  @@questions_count = 4
  serialize :question_1, Hash # I'd hopefully be able be make these dynamic, maybe in the initiliazer
  serialize :question_2, Hash
  serialize :question_3, Hash
  serialize :question_4, Hash

  # Collect the data from all question columns in the table
  def questions
    result = []
    1.upto(questions_count) { |i| result << question(i) }
    result
  end

  def question_titles
    questions.collect { |q| q['title'] }
  end

  # Retrieve the data from a given question column. Data will contain the following info:
  # title = ""
  # description = ""
  # answer_type = [:range, :integer, :option]
  # answer_options = ["option1", .. "option_n"]
  # range_values = [min, .. max]
  def question(n)
    send "question_#{n}"
  end

  def questions_count
    @@questions_count
  end

end
