class RemoveDatetimeFromMessages < ActiveRecord::Migration[7.1]
  def change
    remove_column :messages, :datetime, :string
  end
end
