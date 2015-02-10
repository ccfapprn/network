require "test_helper"

class CheckInSurveyTest < ActiveSupport::TestCase

  def check_in_survey
    @check_in_survey ||= CheckInSurvey.new
  end

  def test_valid
    assert check_in_survey.valid?
  end

end
