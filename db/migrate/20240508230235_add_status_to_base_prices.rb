class AddStatusToBasePrices < ActiveRecord::Migration[7.1]
  def change
    add_column :base_prices, :status, :integer, default: 0, null: false
  end
end
