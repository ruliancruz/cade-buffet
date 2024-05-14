class ChangeStatusDefaultValueFromEventType < ActiveRecord::Migration[7.1]
  def change
    change_table :event_types do |t|
      t.change :status, :integer, default: 1, null: false
    end
  end
end
