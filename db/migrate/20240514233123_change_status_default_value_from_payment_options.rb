class ChangeStatusDefaultValueFromPaymentOptions < ActiveRecord::Migration[7.1]
  def change
    change_table :payment_options do |t|
      t.change :status, :integer, default: 1, null: false
    end
  end
end
