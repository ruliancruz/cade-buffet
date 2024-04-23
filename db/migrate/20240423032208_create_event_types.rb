class CreateEventTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :event_types do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :minimum_attendees, null: false
      t.integer :maximum_attendees, null: false
      t.integer :duration, null: false
      t.string :menu, null: false
      t.integer :provides_alcohol_drinks, null: false
      t.integer :provides_decoration, null: false
      t.integer :provides_parking_service, null: false
      t.integer :serves_external_address, null: false
      t.references :buffet, null: false, foreign_key: true

      t.timestamps
    end
  end
end
