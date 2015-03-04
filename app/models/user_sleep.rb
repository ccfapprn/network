class UserSleep < ActiveRecord::Base
  belongs_to :external_account, primary_key: "validic_id", foreign_key: "validic_id"
  validates :validic_obj_id, uniqueness: true

  def sleep_hours
    sleep = deep + light
    sleep = total_sleep if sleep.nil? || sleep==0
    (sleep / 3600).to_f.round(1)
  end
end
