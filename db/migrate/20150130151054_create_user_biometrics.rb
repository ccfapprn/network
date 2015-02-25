class CreateUserBiometrics < ActiveRecord::Migration
  def change
    create_table :user_biometrics do |t|
      #
      t.string :validic_obj_id, null: false
      t.string :validic_id, null: false
      t.string :timestamp
      t.datetime :timestamp_date
      t.string :utc_offset
      t.string :last_updated
      t.datetime :last_updated_date
      #
      t.float :blood_calcium
      t.float :blood_chromium
      t.float :blood_folic_acid
      t.float :blood_magnesium
      t.float :blood_potassium
      t.float :blood_sodium
      t.float :blood_vitamin_b12
      t.float :blood_zinc
      t.float :creatine_kinase
      t.float :crp
      t.float :diastolic
      t.float :ferritin
      t.float :hdl
      t.float :hscrp
      t.float :il6
      t.float :ldl
      t.float :resting_heartrate
      t.float :systolic
      t.float :testosterone
      t.float :total_cholesterol
      t.float :tsh
      t.float :uric_acid
      t.float :vitamin_d
      t.float :white_cell_count
      t.float :spo2
      t.float :temperature
      t.string :source
      t.string :source_name
      t.timestamps
    end
    add_index :user_biometrics, :validic_obj_id, unique: true
    add_index :user_biometrics, :validic_id
    add_index :user_biometrics, :timestamp_date
  end
end
