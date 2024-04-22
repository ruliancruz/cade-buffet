class CreatePaymentOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_options do |t|
      t.string :name, null: false
      t.integer :installment_limit
      t.references :buffet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
