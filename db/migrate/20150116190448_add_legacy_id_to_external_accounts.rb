class AddLegacyIdToExternalAccounts < ActiveRecord::Migration
  def change
    add_column :external_accounts, :legacy_ccfa_partners_id, :int
  end
end
