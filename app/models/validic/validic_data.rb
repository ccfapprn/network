class ValidicData

  def initialize(org_id,org_access_token)
    @org_id = org_id
    @org_access_token = org_access_token
    @validic_prefix = "https://api.validic.com/v1/"
  end

  def get_objects(validic_obj_name,start_date)
    validic_url = construct_validic_link(validic_obj_name, start_date)
    ret_arr = []
    while validic_url
      response = Faraday.new(:url => validic_url).get
      body = JSON.parse(response.body)
      puts "Getting " + validic_url

      if response.success?
        validic_url = body['summary']['next']
        body[validic_obj_name].each do |obj|
          model = validic_to_model(obj)
          ret_arr << model
        end
      else
        validic_url = nil
      end
    end
    ret_arr
  end

  def validic_to_model(validic_object)
    model = validic_object
    model['validic_id'] = validic_object.delete 'user_id'
    model['validic_obj_id'] = validic_object.delete '_id'
    model['validic_type'] = validic_object.delete 'type' if validic_object.include?('type')
    model['timestamp_date'] = validic_object['timestamp']
    model['last_updated_date'] = validic_object['last_updated']
    model
  end

  def construct_validic_link(obj_name,start_date)
    @validic_prefix + "organizations/#{@org_id}/#{obj_name}/latest.json?access_token=#{@org_access_token}&start_date=#{start_date}"
  end

end
