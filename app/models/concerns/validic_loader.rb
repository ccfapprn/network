# MERGE WITH VALIDIC ADAPTER
class ValidicLoader

  # pass in org_id and org_access_token
  def initialize
    @org_id = Figaro.env.validic_organization_id
    @org_access_token = Figaro.env.validic_access_token
    @validic_object_meta = 
      {
        :biometrics => { :name => 'biometrics', :model => 'UserBiometric' },
        :fitness => { :name => 'fitness', :model => 'UserFitness' },
        :nutrition => { :name => 'nutrition', :model => 'UserNutrition' },
        :routine => { :name => 'routine', :model => 'UserRoutine' },
        :sleep => { :name => 'sleep', :model => 'UserSleep' },
        :tobacco_cessation => { :name => 'tobacco_cessation', :model => 'UserTobacco' },
        :weight => { :name => 'weight', :model => 'UserWeight' }
      }
  end

  def load
    yesterday = Date.yesterday.strftime('%Y-%m-%d')

    @validic_object_meta.each do |obj_meta_key,obj_meta|
      model_name = obj_meta[:model]
      validic_obj_name = obj_meta[:name]
      validic_url = "https://api.validic.com/v1/organizations/#{@org_id}/#{validic_obj_name}/latest.json?access_token=#{@org_access_token}&start_date=#{yesterday}"
      while validic_url
        puts "Getting " + model_name + " at " + validic_url
        conn = Faraday.new(:url => validic_url)
        response = conn.get
        puts 'Success: ' + ((response.success?)?'TRUE':'FALSE')
        hresponse = JSON.parse(response.body)
        validic_url = hresponse['summary']['next']
        hresponse[validic_obj_name].each do |obj|
          model = model_name.constantize.new
          obj['validic_id'] = obj.delete '_id'
          obj['timestamp_date'] = obj['timestamp']
          obj['last_updated_date'] = obj['last_updated']
          model.attributes= obj
          model.save
        end
      #puts JSON.pretty_generate(hresponse)
      end
    end
  end

  #for testing
  def unload
    #model.delete_all
  end
end
