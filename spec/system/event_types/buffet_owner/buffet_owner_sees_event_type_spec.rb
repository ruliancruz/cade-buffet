require 'rails_helper'

describe 'Buffet owner sees event type details' do
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
      .new name: 'Coquetel de Networking Empresarial',
           description: 'Um evento descontraído.',
           minimum_attendees: 20,
           maximum_attendees: 50,
           duration: 120,
           menu: 'Seleção de queijos, frutas e vinhos',
           provides_alcohol_drinks: true,
           provides_decoration: true,
           provides_parking_service: false,
           serves_external_address: false,
           buffet: buffet

    event_type.photo
      .attach(io: File.open('spec/support/table.jpg'),
              filename: 'table.jpg',
              content_type: 'image/jpeg')

    event_type.save!

    login_as buffet_owner, scope: :buffet_owner
    visit buffet_path buffet
    click_on 'Coquetel de Networking Empresarial'

    expect(current_path).to eq event_type_path event_type

    expect(page).to have_content 'Você precisa cadastrar um preço base para ' \
                                 'receber pedidos de clientes'

    expect(page).to have_content 'Coquetel de Networking Empresarial'
    expect(page).to have_css 'img[src*="table.jpg"]'
    expect(page).to have_content 'Um evento descontraído'
    expect(page).to have_content 'Mínimo de Pessoas 20'
    expect(page).to have_content 'Máximo de Pessoas 50'
    expect(page).to have_content 'Duração 120 minutos'
    expect(page).to have_content 'Cardápio'
    expect(page).to have_content 'Seleção de queijos, frutas e vinhos'
    expect(page).to have_content 'Fornece Bebidas Alcoólicas Sim'
    expect(page).to have_content 'Fornece Decoração Sim'
    expect(page).to have_content 'Fornece Serviço de Estacionamento Não'
    expect(page).to have_content 'Atende a Endereço Indicado por Cliente Não'
  end

  it "and doesn't see add, edit and delete buttons if he access an event " \
     "type from another buffet" do
    first_buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second.buffet_owner@example.com',
               password: 'second-password'

    first_buffet = Buffet
      .create! corporate_name: 'Sabores Deliciosos Ltda.',
               brand_name: 'Chef & Cia Buffet',
               cnpj: '34340299000145',
               phone: '9887654321',
               address: 'Avenida das Delícias, 456',
               district: 'Gourmet',
               city: 'Saborville',
               state: 'SP',
               cep: '87654321',
               buffet_owner: first_buffet_owner

    second_buffet = Buffet
      .create! corporate_name: 'Delícias Gastronômicas Ltda.',
               brand_name: 'Sabor & Arte Buffet',
               cnpj: '96577377000187',
               phone: '7531274464',
               address: 'Rua dos Sabores, 123',
               district: 'Centro',
               city: 'Culinária City',
               state: 'BA',
               cep: '12345678',
               buffet_owner: second_buffet_owner

    EventType
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
               buffet: first_buffet

    second_event_type = EventType
      .create! name: 'Festa de Aniversário infantil',
               description: 'Um evento muito legal.',
               minimum_attendees: 10,
               maximum_attendees: 40,
               duration: 80,
               menu: 'Bolos, salgados, sucos e refrigerantes',
               provides_alcohol_drinks: false,
               provides_decoration: true,
               provides_parking_service: false,
               serves_external_address: true,
               buffet: second_buffet

    login_as first_buffet_owner, scope: :buffet_owner
    visit event_type_path second_event_type

    expect(page).to have_content 'Festa de Aniversário infantil'
    expect(page).not_to have_link 'Alterar Dados'
    expect(page).not_to have_link 'Adicionar Preço-base'
    expect(page).not_to have_button 'Excluir'
    expect(page).not_to have_button 'Remover'
  end


  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    login_as buffet_owner, scope: :buffet_owner
    visit event_type_path 1

    expect(current_path).to eq new_buffet_path

    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end