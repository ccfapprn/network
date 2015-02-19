require "test_helper"

class UserWeightTest < ActiveSupport::TestCase

  def user_weight
    @user_weight ||= UserWeight.new
  end

  def test_valid
    assert user_weight.valid?
  end

end
