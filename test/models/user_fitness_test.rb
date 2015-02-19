require "test_helper"

class UserFitnessTest < ActiveSupport::TestCase

  def user_fitness
    @user_fitness ||= UserFitness.new
  end

  def test_valid
    assert user_fitness.valid?
  end

end
