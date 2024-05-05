class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.date :date, null: false
      t.integer :attendees, null: false
      t.string :details, null: false
      t.string :code, null: false
      t.string :address
      t.integer :status, null: false
      t.date :expiration_date
      t.float :price_adjustment
      t.string :price_adjustment_description
      t.references :client, null: false, foreign_key: true
      t.references :event_type, null: false, foreign_key: true
      t.references :payment_option, foreign_key: true

      t.timestamps
    end
  end
end
