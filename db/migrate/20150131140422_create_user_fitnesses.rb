class CreateUserFitnesses < ActiveRecord::Migration
  def change
    create_table :user_fitnesses do |t|
      #
      t.string :validic_obj_id, null: false
      t.string :validic_id, null: false
      t.string :timestamp
      t.datetime :timestamp_date
      t.string :utc_offset
      t.string :last_updated
      t.datetime :last_updated_date
      #
      t.string :type
      t.float :intensity
      t.string :start_time
      t.float :distance
      t.float :duration
      t.float :calories
      t.string :source
      t.string :source_name
      #
      t.timestamps
    end
    add_index :user_fitnesses, :validic_obj_id, unique: true
    add_index :user_fitnesses, :validic_id
    add_index :user_fitnesses, :timestamp_date
  end
end
