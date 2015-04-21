namespace :routine do

  desc "Routine cleanup tasks to re-sync with OODT and update caches etc"
  task :maintenance => :environment do
    puts "Running all important regular routine maintenance tasks"

    puts "  + Updating OODT's next_survey date and url for all users..."
    User.find_each do |u|
      puts "   - On user id #{u.id}..."
      u.get_survey_scorecard #this updates whether they have a new survey to do or not
    end

  end

end