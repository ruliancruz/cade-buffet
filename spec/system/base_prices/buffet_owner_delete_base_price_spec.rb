require 'rails_helper'

describe 'Buffet owner deletes a base-price' do
  it 'with success' do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    buffet = Buffet
      .create! corporate_name: 'Delícias Gastronômicas Ltda.',
               brand_name: 'Sabor & Arte Buffet',
               cnpj: '34340299000145',
               phone: '7531274464',
               address: 'Rua dos Sabores, 123',
               district: 'Centro',
               city: 'Culinária City',
               state: 'BA',
               cep: '12345678',
               buffet_owner: buffet_owner

    event_type = EventType
      .create! name: 'Coquetel de Networking Empresarial',
               description: 'Um evento descontraído.',
               minimum_attendees: 20,
               maximum_attendees: 50,
               duration: 120,
               menu: 'Seleção de queijos, frutas e vinhos',
               provides_alcohol_drinks: true,
               provides_decoration: false,
               provides_parking_service: false,
               serves_external_address: false,
               buffet: buffet

    BasePrice
      .create! description: 'Meio de Semana',
               minimum: 10_000,
               additional_per_person: 250,
               extra_hour_value: 1_000,
               event_type: event_type

    BasePrice
      .create! description: 'Final de Semana',
               minimum: 14_000,
               additional_per_person: 300,
               extra_hour_value: 1_500,
               event_type: event_type

    login_as buffet_owner, scope: :buffet_owner
    visit event_type_path event_type

    first(:button, 'Remover').click

    expect(current_path).to eq event_type_path event_type

    expect(page).to have_content 'Preço-base removido com sucesso!'

    expect(page).not_to have_content 'Meio de Semana'
    expect(page).not_to have_content 'Valor Mínimo: R$10.000,00'
    expect(page).not_to have_content 'Adicional por Pessoa: R$250,00'
    expect(page).not_to have_content 'Valor por Hora Extra: R$1.000,00'
  end
end