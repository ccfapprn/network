json.array!(@check_in_surveys) do |check_in_survey|
  json.extract! check_in_survey, :id, :title, :description, :question_1, :question_2, :question_3, :question_4
  json.url check_in_survey_url(check_in_survey, format: :json)
end
