require "test_helper"

class CheckInResponseTest < ActiveSupport::TestCase

  def check_in_response
    @check_in_response ||= CheckInResponse.new
  end

  def test_valid
    assert check_in_response.valid?
  end

end
