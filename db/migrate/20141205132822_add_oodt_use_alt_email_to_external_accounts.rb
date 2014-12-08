class AddOodtUseAltEmailToExternalAccounts < ActiveRecord::Migration
  def change
    add_column :external_accounts, :oodt_use_alt_email, :boolean
  end
end
