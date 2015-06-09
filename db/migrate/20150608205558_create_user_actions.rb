class CreateUserActions < ActiveRecord::Migration
  def change
    create_table :user_actions do |t|
      t.integer :user_id
      t.string :action

      t.timestamps
    end
    add_index :user_actions, :user_id
  end
end
