class UserRoutine < ActiveRecord::Base
  belongs_to :external_account, primary_key: "validic_id", foreign_key: "validic_id"
  validates :validic_obj_id, uniqueness: true
end
