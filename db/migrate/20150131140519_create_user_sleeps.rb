class CreateUserSleeps < ActiveRecord::Migration
  def change
    create_table :user_sleeps do |t|
      #
      t.string :validic_id, null: false
      t.string :user_id, null: false
      t.string :timestamp
      t.datetime :timestamp_date
      t.string :utc_offset
      t.string :last_updated
      t.datetime :last_updated_date
      #
      t.float :awake
      t.float :deep
      t.float :light
      t.float :rem
      t.float :times_woken
      t.float :total_sleep
      t.string :source
      t.string :source_name
      #
      t.timestamps
    end
    add_index :user_sleeps, :validic_id, unique: true
    add_index :user_sleeps, :user_id
    add_index :user_sleeps, :timestamp_date
  end
end
