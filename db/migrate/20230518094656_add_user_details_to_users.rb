class AddUserDetailsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string
    add_column :users, :photo_url, :string
    add_column :users, :telegram_user_id, :bigint
  end
end
