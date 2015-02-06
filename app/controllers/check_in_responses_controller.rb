class CheckInResponsesController < ApplicationController
  before_action :set_check_in_response, only: [:show, :edit, :update, :destroy]

  respond_to :html

  # def index
  #   @check_in_responses = CheckInResponse.all
  #   respond_with(@check_in_responses)
  # end

  # def show
  #   respond_with(@check_in_response)
  # end

  def new
    @check_in_response = current_user.check_in_responses.build
    respond_with(@check_in_response)
  end

  # def edit
  # end

  def create
    @check_in_response = CheckInResponse.new(check_in_response_params.merge(user_id: current_user.id, check_in_survey_id: 1))
    flash[:error] = 'There was a problem saving your health check in.' if !@check_in_response.save
    respond_with(@check_in_response, location: health_data_path)
  end

  def update
    flash[:error] = 'There was a problem saving your health check in.' if !@check_in_response.update(check_in_response_params)
    respond_with(@check_in_response, location: health_data_path)
  end

  # def destroy
  #   @check_in_response.destroy
  #   respond_with(@check_in_response)
  # end

  private
    def set_check_in_response
      @check_in_response = CheckInResponse.find(params[:id])
    end

    def check_in_response_params
      params.require(:check_in_response).permit(:user_id, :check_in_survey_id, :answer_1, :answer_2, :answer_3, :answer_4)
    end
end
