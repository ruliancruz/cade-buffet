class ChangeStatusDefaultValueFromBasePrices < ActiveRecord::Migration[7.1]
  def change
    change_table :base_prices do |t|
      t.change :status, :integer, default: 1, null: false
    end
  end
end
