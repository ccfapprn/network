require "test_helper"

class UserActionTest < ActiveSupport::TestCase

  def user_action
    @user_action ||= UserAction.new
  end

  def test_valid
    assert user_action.valid?
  end

end
