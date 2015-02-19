require "test_helper"

class UserBiometricTest < ActiveSupport::TestCase

  def user_biometric
    @user_biometric ||= UserBiometric.new
  end

  def test_valid
    assert user_biometric.valid?
  end

end
