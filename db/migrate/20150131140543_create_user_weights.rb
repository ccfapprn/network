class CreateUserWeights < ActiveRecord::Migration
  def change
    create_table :user_weights do |t|
      #
      t.string :validic_id, null: false
      t.string :user_id, null: false
      t.string :timestamp
      t.datetime :timestamp_date
      t.string :utc_offset
      t.string :last_updated
      t.datetime :last_updated_date
      #
      t.float :weight
      t.float :height
      t.float :free_mass
      t.float :fat_percent
      t.float :mass_weight
      t.float :bmi
      t.string :source
      t.string :source_name
      #
      t.timestamps
    end
    add_index :user_weights, :validic_id, unique: true
    add_index :user_weights, :user_id
    add_index :user_weights, :timestamp_date
  end
end
