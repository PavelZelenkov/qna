class AddAuthorId < ActiveRecord::Migration[7.2]
  def change
    add_reference :answers, :author, foreign_key: {to_table: :users}
    add_reference :questions, :author, foreign_key: {to_table: :users}
  end
end
