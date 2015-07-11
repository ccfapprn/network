class AddCrohnologyAuthToExternalAccounts < ActiveRecord::Migration
  def change
    add_column :external_accounts, :crohnology_token, :text

  end
end
