class ChangeNullOptionsFromClients < ActiveRecord::Migration[7.1]
  change_table :clients do |t|
    t.change :name, :string
    t.change :cpf, :string
  end
end
