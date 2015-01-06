require "test_helper"

class MailerControllerTest < ActionController::TestCase
  def test_validate
    get :validate
    assert_response :success
  end

  def test_generate
    get :generate
    assert_response :success
  end

end
