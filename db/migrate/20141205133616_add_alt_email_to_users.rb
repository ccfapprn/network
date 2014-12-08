class AddAltEmailToUsers < ActiveRecord::Migration
  def change
    add_column :users, :alt_email, :string
    add_index :users, :alt_email
    add_column :users, :alt_email_confirmed, :boolean
    add_column :users, :alt_confirmation_token, :string
    add_column :users, :alt_confirmed_at, :timestamp
    add_column :users, :alt_confirmation_sent_at, :timestamp
  end
end
