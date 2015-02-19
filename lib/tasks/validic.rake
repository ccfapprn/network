namespace :validic do
  desc "TODO"
  task load: :environment do

    loader = ValidicLoader.new
    loader.load

  end

  desc "TODO"
  task unload: :environment do
  end

end
