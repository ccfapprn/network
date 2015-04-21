class AddNextSurveyInfoCache < ActiveRecord::Migration
  def change
    add_column :external_accounts, :next_survey_date, :datetime
    add_column :external_accounts, :next_survey_url, :string
  end
end
