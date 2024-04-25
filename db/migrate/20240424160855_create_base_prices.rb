class CreateBasePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :base_prices do |t|
      t.string :description, null: false
      t.integer :minimum, null: false
      t.integer :additional_per_person, null: false
      t.integer :extra_hour_value
      t.references :event_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
