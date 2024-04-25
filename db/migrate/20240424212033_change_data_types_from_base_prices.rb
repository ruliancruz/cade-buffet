class ChangeDataTypesFromBasePrices < ActiveRecord::Migration[7.1]
  def change
    change_table :base_prices do |t|
      t.change :minimum, :float
      t.change :additional_per_person, :float
      t.change :extra_hour_value, :float
    end
  end
end
