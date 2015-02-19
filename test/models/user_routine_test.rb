require "test_helper"

class UserRoutineTest < ActiveSupport::TestCase

  def user_routine
    @user_routine ||= UserRoutine.new
  end

  def test_valid
    assert user_routine.valid?
  end

end
