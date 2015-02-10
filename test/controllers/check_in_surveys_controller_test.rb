require "test_helper"

class CheckInSurveysControllerTest < ActionController::TestCase

  def check_in_survey
    @check_in_survey ||= check_in_surveys :one
  end

  def test_index
    get :index
    assert_response :success
    assert_not_nil assigns(:check_in_surveys)
  end

  def test_new
    get :new
    assert_response :success
  end

  def test_create
    assert_difference('CheckInSurvey.count') do
      post :create, check_in_survey: { description: check_in_survey.description, name: check_in_survey.name, question_1: check_in_survey.question_1, question_2: check_in_survey.question_2, question_3: check_in_survey.question_3, question_4: check_in_survey.question_4 }
    end

    assert_redirected_to check_in_survey_path(assigns(:check_in_survey))
  end

  def test_show
    get :show, id: check_in_survey
    assert_response :success
  end

  def test_edit
    get :edit, id: check_in_survey
    assert_response :success
  end

  def test_update
    put :update, id: check_in_survey, check_in_survey: { description: check_in_survey.description, name: check_in_survey.name, question_1: check_in_survey.question_1, question_2: check_in_survey.question_2, question_3: check_in_survey.question_3, question_4: check_in_survey.question_4 }
    assert_redirected_to check_in_survey_path(assigns(:check_in_survey))
  end

  def test_destroy
    assert_difference('CheckInSurvey.count', -1) do
      delete :destroy, id: check_in_survey
    end

    assert_redirected_to check_in_surveys_path
  end
end
