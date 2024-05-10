require 'rails_helper'

describe 'Buffet owner deletes a event type' do
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

    login_as buffet_owner, scope: :buffet_owner
    visit event_type_path event_type
    click_on 'Excluir'

    expect(current_path).to eq buffet_path event_type

    expect(page).to have_content 'Tipo de evento excluído com sucesso!'
    expect(page).not_to have_content 'Coquetel de Networking Empresarial'
    expect(page).not_to have_content 'Um evento descontraído.'
  end
end