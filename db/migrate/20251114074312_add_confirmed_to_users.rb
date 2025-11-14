class AddConfirmedToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :confirmed, :boolean, default: false
  end
end
