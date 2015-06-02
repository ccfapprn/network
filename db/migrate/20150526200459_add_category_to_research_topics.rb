class AddCategoryToResearchTopics < ActiveRecord::Migration
  def change
    add_column :research_topics, :category, :string, :default => 'other'
    add_column :research_topics, :archive_date, :date
    add_index :research_topics, :category
    add_index :research_topics, :archive_date

   ResearchTopic.update_all :category => 'other'
  end
end
