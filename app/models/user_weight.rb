class UserWeight < ActiveRecord::Base
  validates :validic_id, uniqueness: true
end
