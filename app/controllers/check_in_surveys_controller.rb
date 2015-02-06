# class CheckInSurveysController < ApplicationController
#   before_action :set_check_in_survey, only: [:show, :edit, :update, :destroy]

#   respond_to :html

#   def index
#     @check_in_surveys = CheckInSurvey.all
#     respond_with(@check_in_surveys)
#   end

#   def show
#     respond_with(@check_in_survey)
#   end

#   def new
#     @check_in_survey = CheckInSurvey.new
#     respond_with(@check_in_survey)
#   end

#   def edit
#   end

#   def create
#     @check_in_survey = CheckInSurvey.new(check_in_survey_params)
#     flash[:notice] = 'CheckInSurvey was successfully created.' if @check_in_survey.save
#     respond_with(@check_in_survey)
#   end

#   def update
#     flash[:notice] = 'CheckInSurvey was successfully updated.' if @check_in_survey.update(check_in_survey_params)
#     respond_with(@check_in_survey)
#   end

#   def destroy
#     @check_in_survey.destroy
#     respond_with(@check_in_survey)
#   end

#   private
#     def set_check_in_survey
#       @check_in_survey = CheckInSurvey.find(params[:id])
#     end

#     def check_in_survey_params
#       params.require(:check_in_survey).permit(:name, :description, :question_1, :question_2, :question_3, :question_4)
#     end
# end
