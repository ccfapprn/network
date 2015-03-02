namespace :validic do
  desc "Load validic data"
  task load: :environment do
    validic_data = ValidicData.new(Figaro.env.validic_organization_id, Figaro.env.validic_access_token)
    loader = ValidicLoader.new(validic_data)
    loader.load
  end

  desc "Unload validic data, REMOVE AFTER TESTING COMPLETE"
  task unload: :environment do
    validic_data = ValidicData.new(Figaro.env.validic_organization_id, Figaro.env.validic_access_token)
    loader = ValidicLoader.new(validic_data)
    loader.unload
  end

end
