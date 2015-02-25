class CreateUserRoutines < ActiveRecord::Migration
  def change
    create_table :user_routines do |t|
      #
      t.string :validic_obj_id, null: false
      t.string :validic_id, null: false
      t.string :timestamp
      t.datetime :timestamp_date
      t.string :utc_offset
      t.string :last_updated
      t.datetime :last_updated_date
      #
      t.float :steps
      t.float :calories_burned
      t.float :distance
      t.float :floors
      t.float :elevation
      t.string :source
      t.string :source_name
      t.timestamps
    end
    add_index :user_routines, :validic_obj_id, unique: true
    add_index :user_routines, :validic_id
    add_index :user_routines, :timestamp_date
  end
end
