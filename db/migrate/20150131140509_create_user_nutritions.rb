class CreateUserNutritions < ActiveRecord::Migration
  def change
    create_table :user_nutritions do |t|
      #
      t.string :validic_id, null: false
      t.string :user_id, null: false
      t.string :timestamp
      t.datetime :timestamp_date
      t.string :utc_offset
      t.string :last_updated
      t.datetime :last_updated_date
      #
      t.float :calories
      t.float :carbohydrates
      t.float :fat
      t.float :fiber
      t.float :protein
      t.float :sodium
      t.float :water
      t.string :meal
      t.string :source
      t.string :source_name
      #
      t.timestamps
    end
    add_index :user_nutritions, :validic_id, unique: true
    add_index :user_nutritions, :user_id
    add_index :user_nutritions, :timestamp_date
  end
end
