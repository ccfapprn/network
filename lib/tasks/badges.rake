namespace :badges do

  desc "Clean Badges Awarded to Users (Make sure users have and only have badges they've earned)"
  task :clean => :environment do
    num_awarded_badges = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM BADGES_SASHES").values.first.first

    puts "There are #{num_awarded_badges} currently awarded. Now cleaning....."

    User.find_each do |u|
      u.clean_up_survey_badges
    end

    num_awarded_badges = ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM BADGES_SASHES").values.first.first
    puts "Complete. There are now #{num_awarded_badges} awarded. If there is a difference, thank the cleaner."

  end

end