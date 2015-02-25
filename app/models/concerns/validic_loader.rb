# MERGE WITH VALIDIC ADAPTER
class ValidicLoader
  attr_accessor :debug

  def initialize(org_id,org_access_token)
    @org_id = org_id
    @org_access_token = org_access_token
    @validic_prefix = "https://api.validic.com/v1/"
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

  def load_org_latest
    load { |obj_name,start_date| @validic_prefix + "organizations/#{@org_id}/#{obj_name}/latest.json?access_token=#{@org_access_token}&start_date=#{start_date}" }
  end

  def load_user(user)
    if user.validic_id
      @user = user
      load { |obj_name,start_date| @validic_prefix + "organizations/#{@org_id}/users/#{@user.validic_id}/#{obj_name}/latest.json?access_token=#{@org_access_token}&start_date=#{start_date}" }
      #load { |obj_name,start_date| @validic_prefix + "organizations/#{@org_id}/users/#{@user.validic_id}/#{obj_name}.json/access_token=#{@org_access_token}"}
    else
      return false
    end
  end

  #for testing
  def unload
    #model.delete_all
  end

  #def validic_link(obj_name)
  #  if @user_access_token
  #    "https://api.validic.com/v1/organizations/#{@org_id}/users/#{obj_name}.json/access_token=#{@user_access_token}"
  #  else
  #    "https://api.validic.com/v1/organizations/#{@org_id}/#{obj_name}/latest.json?access_token=#{@org_access_token}&start_date=#{yesterday}"
  #  end
  #end

  private

  def load
    yesterday = Date.yesterday.strftime('%Y-%m-%d')

    @validic_object_meta.each do |obj_meta_key,obj_meta|
      model_name = obj_meta[:model]
      validic_obj_name = obj_meta[:name]
      #validic_url = "https://api.validic.com/v1/organizations/#{@org_id}/#{validic_obj_name}/latest.json?access_token=#{@org_access_token}&start_date=#{yesterday}"
      validic_url = yield validic_obj_name,yesterday
      while validic_url
        puts "Getting " + model_name + " at " + validic_url
        conn = Faraday.new(:url => validic_url)
        response = conn.get
        puts 'Success: ' + ((response.success?)?'TRUE':'FALSE')
        hresponse = JSON.parse(response.body)
        puts JSON.pretty_generate(hresponse) if @debug
        if response.success?
          validic_url = hresponse['summary']['next']
          hresponse[validic_obj_name].each do |obj|
            model = model_name.constantize.new
            if @user
              obj['validic_id'] = @user.validic_id
            else
              obj['validic_id'] = obj.delete 'user_id'
            end
            obj['validic_obj_id'] = obj.delete '_id'
            obj['timestamp_date'] = obj['timestamp']
            obj['last_updated_date'] = obj['last_updated']
            model.attributes= obj
            model.save
          end
        else
          validic_url = nil
        end
      end
    end
  end


end
