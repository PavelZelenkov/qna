class AddStatusToAnswers < ActiveRecord::Migration[7.2]
  def change
    add_column :answers, :status, :integer, default: 0
  end
end
