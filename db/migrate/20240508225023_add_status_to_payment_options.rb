class AddStatusToPaymentOptions < ActiveRecord::Migration[7.1]
  def change
    add_column :payment_options, :status, :integer, default: 0, null: false
  end
end
