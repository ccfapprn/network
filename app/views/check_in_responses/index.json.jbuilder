json.array!(@check_in_responses) do |check_in_response|
  json.extract! check_in_response, :id, :user_id, :check_in_survey_id, :answer_1, :answer_2, :answer_3, :answer_4
  json.url check_in_response_url(check_in_response, format: :json)
end
