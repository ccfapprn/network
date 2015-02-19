class CreateCheckInSurveys < ActiveRecord::Migration
  def change
    create_table :check_in_surveys do |t|
      t.string :title
      t.text :description
      t.string :version, index: true
      t.text :question_1
      t.text :question_2
      t.text :question_3
      t.text :question_4

      t.timestamps
    end
  end
end
