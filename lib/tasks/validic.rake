namespace :validic do
  desc "TODO"
  task load: :environment do

    loader = ValidicLoader.new(Figaro.env.validic_organization_id, Figaro.env.validic_access_token)
    loader.load

  end

  desc "TODO"
  task unload: :environment do
  end

end
