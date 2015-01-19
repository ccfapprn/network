class GrantAllUsersSocialProfiles < ActiveRecord::Migration
  def change
    User.all.each do |u|
      if !u.social_profile
        u.build_social_profile
        u.save
      end
    end
  end
end
