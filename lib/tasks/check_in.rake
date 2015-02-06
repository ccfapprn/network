namespace :check_in_surveys do

  desc "Update Check in Surveys from YMLs"
  task :update => :environment do
    return unless warn("WARNING: You are about to update the check in survey templates in the DB. If they are using the same version numbers as existing survey templates, those templates will be overwritten.")

    check_in_survey_files = Dir["lib/data/check_in_surveys/*.yml"]

    check_in_survey_files.each do |check_in_survey_file|
      survey_info = YAML.load_file(check_in_survey_file)

      ## Unless the file is empty or nonexistent...
      unless survey_info.empty?
        # See if a matching version is already in the DB
        existing_survey = CheckInSurvey.find_by(survey_info.slice('version'))

        if existing_survey
          # If there is already a matching version in the DB, then only update it
          existing_survey.update(survey_info)
        else
          # If this version is non-existent, then create it
          CheckInSurvey.create(survey_info)
        end
      end

    end


    puts "Complete. There are now #{CheckInSurvey.count} Check-In Surveys in the DB."

  end

  desc "Destroy all surveys in the DB"
  task :clear => :environment do
    if warn("WARNING: You are about to destroy all surveys AND responses currently in the database.")
      CheckInSurvey.destroy_all
      CheckInResponse.destroy_all
      puts "DESTROYED SURVEYS AND RESPONSES"
    end
  end


  desc "Destroy all surveys in the DB and Re-instantiate Surveys"
  task :refresh => :environment do
    Rake::Task["check_in_surveys:clear"].invoke
    Rake::Task["check_in_surveys:update"].invoke
  end



  def warn(msg)
    puts msg
    puts "Are you sure you want to continue? (y/n)"

    STDIN.gets.strip.downcase == 'y'
  end

end