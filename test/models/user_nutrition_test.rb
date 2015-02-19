require "test_helper"

class UserNutritionTest < ActiveSupport::TestCase

  def user_nutrition
    @user_nutrition ||= UserNutrition.new
  end

  def test_valid
    assert user_nutrition.valid?
  end

end
