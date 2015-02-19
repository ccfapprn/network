require "test_helper"

class UserSleepTest < ActiveSupport::TestCase

  def user_sleep
    @user_sleep ||= UserSleep.new
  end

  def test_valid
    assert user_sleep.valid?
  end

end
