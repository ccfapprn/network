namespace :check_in_surveys do

  desc "Update Check in Surveys from YMLs"
  task :update => :environment do

    check_in_survey_files = Dir["lib/data/check_in_surveys/*.yml"]
    check_in_survey_files.each do |check_in_survey_file|
      survey_info = YAML.load_file(check_in_survey_file)

      byebug

      unless survey_info.false? || survey_info.empty?
        existing_survey = CheckInSurvey.find_by(survey_info.slice('version'))

        if existing_survey
          existing_survey.update(survey_info)
        else
          CheckInSurvey.create(survey_info)
        end
      end

      byebug

    end

  end




end