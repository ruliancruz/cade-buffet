class ChangeNullOptionsFromBasePrices < ActiveRecord::Migration[7.1]
  change_table :base_prices do |t|
    t.change :minimum, :float, null:false
    t.change :additional_per_person, :float, null:false
  end
end
