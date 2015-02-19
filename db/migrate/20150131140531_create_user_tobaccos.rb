class CreateUserTobaccos < ActiveRecord::Migration
  def change
    create_table :user_tobaccos do |t|
      #
      t.string :validic_id, null: false
      t.string :user_id, null: false
      t.string :timestamp
      t.datetime :timestamp_date
      t.string :utc_offset
      t.string :last_updated
      t.datetime :last_updated_date
      #
      t.float :cigarettes_allowed
      t.float :cigarettes_smoked
      t.float :cravings
      t.string :last_smoked
      t.string :source
      t.string :source_name
      #
      t.timestamps
    end
    add_index :user_tobaccos, :validic_id, unique: true
    add_index :user_tobaccos, :user_id
    add_index :user_tobaccos, :timestamp_date
  end
end
