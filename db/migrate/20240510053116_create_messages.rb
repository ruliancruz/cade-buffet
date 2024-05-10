class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.string :text, null: false
      t.datetime :datetime, null: false
      t.integer :author, null: false

      t.timestamps
    end
  end
end
