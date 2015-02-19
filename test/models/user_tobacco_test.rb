require "test_helper"

class UserTobaccoTest < ActiveSupport::TestCase

  def user_tobacco
    @user_tobacco ||= UserTobacco.new
  end

  def test_valid
    assert user_tobacco.valid?
  end

end
