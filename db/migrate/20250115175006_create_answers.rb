class CreateAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :answers do |t|
      t.string :body
      t.references :question, foreign_key: true, null: false

      t.timestamps
    end
  end
end
