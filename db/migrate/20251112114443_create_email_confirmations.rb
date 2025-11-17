class CreateEmailConfirmations < ActiveRecord::Migration[7.2]
  def change
    create_table :email_confirmations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :token
      t.boolean :confirmed, default: false

      t.timestamps
    end
  end
end
