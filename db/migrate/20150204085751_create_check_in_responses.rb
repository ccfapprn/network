class CreateCheckInResponses < ActiveRecord::Migration
  def change
    create_table :check_in_responses do |t|
      t.integer :user_id
      t.integer :check_in_survey_id
      t.integer :answer_1
      t.integer :answer_2
      t.integer :answer_3
      t.integer :answer_4

      t.timestamps
    end
    add_index :check_in_responses, :user_id
  end
end
