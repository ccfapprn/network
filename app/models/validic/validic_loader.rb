class ValidicLoader

  def initialize(validic_db)
    @validic_db = validic_db
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

  #for testing?
  def unload
    @validic_object_meta.each do |obj_meta_key,obj_meta|
      model_name = obj_meta[:model]
      model = model_name.constantize
      model.delete_all
    end
  end

  def load(start_date=nil)
    start_date = Date.yesterday.strftime('%Y-%m-%d') if start_date.nil?
    @validic_object_meta.each do |obj_meta_key,obj_meta|
      model_name = obj_meta[:model]
      validic_obj_name = obj_meta[:name]
      obj_arr = @validic_db.get_objects(validic_obj_name,start_date)
      # log error?
      rails "validic_db.get_objects call failed" if obj_arr == false
      obj_arr.each do |obj|
        model = model_name.constantize.new
        model.attributes= obj
        model.save
      end
    end
  end
end