require "test_helper"

class CheckInResponsesControllerTest < ActionController::TestCase

  def check_in_response
    @check_in_response ||= check_in_responses :one
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:check_in_responses)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('CheckInResponse.count') do
      post :create, check_in_response: { answer_1: check_in_response.answer_1, answer_2: check_in_response.answer_2, answer_3: check_in_response.answer_3, answer_4: check_in_response.answer_4, check_in_survey_id: check_in_response.check_in_survey_id, user_id: check_in_response.user_id }
    end

    assert_redirected_to check_in_response_path(assigns(:check_in_response))
  end

  def test_show
    get :show, id: check_in_response
    assert_response :success
  end

  def test_edit
    get :edit, id: check_in_response
    assert_response :success
  end

  def test_update
    put :update, id: check_in_response, check_in_response: { answer_1: check_in_response.answer_1, answer_2: check_in_response.answer_2, answer_3: check_in_response.answer_3, answer_4: check_in_response.answer_4, check_in_survey_id: check_in_response.check_in_survey_id, user_id: check_in_response.user_id }
    assert_redirected_to check_in_response_path(assigns(:check_in_response))
  end

  def test_destroy
    assert_difference('CheckInResponse.count', -1) do
      delete :destroy, id: check_in_response
    end

    assert_redirected_to check_in_responses_path
  end
end
