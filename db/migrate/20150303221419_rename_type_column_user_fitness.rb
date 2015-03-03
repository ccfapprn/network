class RenameTypeColumnUserFitness < ActiveRecord::Migration
  def change
    rename_column :user_fitnesses, :type, :validic_type
  end
end
