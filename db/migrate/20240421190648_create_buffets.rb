class CreateBuffets < ActiveRecord::Migration[7.1]
  def change
    create_table :buffets do |t|
      t.string :brand_name, null: false
      t.string :corporate_name, null: false
      t.string :cnpj, null: false
      t.string :phone, null: false
      t.string :address, null: false
      t.string :district, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :cep, null: false
      t.string :description
      t.references :buffet_owner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
