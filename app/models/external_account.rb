class ExternalAccount < ActiveRecord::Base
  belongs_to :user
  has_many :user_biometric, -> { order "timestamp_date desc" }, primary_key: "validic_id", foreign_key: "validic_id"
  has_many :user_fitness, -> { order "timestamp_date desc" }, primary_key: "validic_id", foreign_key: "validic_id"
  has_many :user_nutrition, -> { order "timestamp_date desc" }, primary_key: "validic_id", foreign_key: "validic_id"
  has_many :user_routine, -> { order "timestamp_date desc" }, primary_key: "validic_id", foreign_key: "validic_id"
  has_many :user_sleep, -> { order "timestamp_date desc" }, primary_key: "validic_id", foreign_key: "validic_id"
  has_many :user_tobacco, -> { order "timestamp_date desc" }, primary_key: "validic_id", foreign_key: "validic_id"
  has_many :user_weight, -> { order "timestamp_date desc" }, primary_key: "validic_id", foreign_key: "validic_id"
end