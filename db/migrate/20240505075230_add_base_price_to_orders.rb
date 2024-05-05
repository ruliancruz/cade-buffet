class AddBasePriceToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :base_price, foreign_key: true
  end
end
