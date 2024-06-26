require 'rails_helper'

describe 'Buffet owner edits a event type' do
  it 'from the event type page' do
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
    click_on 'Alterar Dados'

    expect(current_path).to eq edit_event_type_path event_type

    within 'h1' do
      expect(page).to have_content 'Editar Tipo de Evento'
    end

    within 'main form' do
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Mínimo de Pessoas'
      expect(page).to have_field 'Máximo de Pessoas'
      expect(page).to have_field 'Duração'
      expect(page).to have_field 'Cardápio'

      expect(page).to have_content 'Opções Adicionais'
      expect(page).to have_field 'Fornece Bebidas Alcoólicas'
      expect(page).to have_field 'Fornece Decoração'
      expect(page).to have_field 'Fornece Serviço de Estacionamento'
      expect(page).to have_field 'Atende a Endereço Indicado por Cliente'

      expect(page).to have_button 'Atualizar Tipo de Evento'
    end
  end

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
           provides_decoration: false,
           provides_parking_service: false,
           serves_external_address: false,
           buffet: buffet

    event_type.photo
      .attach(io: File.open('spec/support/table.jpg'),
              filename: 'table.jpg',
              content_type: 'image/jpeg')

    event_type.save!

    login_as buffet_owner, scope: :buffet_owner
    visit edit_event_type_path event_type

    within 'main form' do
      fill_in 'Nome', with: 'Coquetel de Networking Social'
      fill_in 'Descrição', with: 'Um evento descontraído e casual.'
      fill_in 'Mínimo de Pessoas', with: '30'
      fill_in 'Máximo de Pessoas', with: '100'
      fill_in 'Duração', with: '180'

      fill_in 'Cardápio',
        with: 'Seleção de queijos, frutas, sucos e refrigerantes'

      attach_file 'Foto', 'spec/support/anniversary.jpg'
      uncheck 'Fornece Bebidas Alcoólicas'
      uncheck 'Fornece Decoração'
      check 'Fornece Serviço de Estacionamento'
      check 'Atende a Endereço Indicado por Cliente'
      click_on 'Atualizar Tipo de Evento'
    end

    expect(current_path).to eq event_type_path event_type

    expect(page).to have_content 'Coquetel de Networking Social'
    expect(page).to have_css 'img[src*="anniversary.jpg"]'
    expect(page).not_to have_css 'img[src*="table.jpg"]'
    expect(page).to have_content 'Um evento descontraído e casual.'
    expect(page).to have_content 'Mínimo de Pessoas 30'
    expect(page).to have_content 'Máximo de Pessoas 100'
    expect(page).to have_content 'Duração 180'

    expect(page)
      .to have_content 'Seleção de queijos, frutas, sucos e refrigerantes'

    expect(page).to have_content 'Fornece Bebidas Alcoólicas Não'
    expect(page).to have_content 'Fornece Decoração Não'
    expect(page).to have_content 'Fornece Serviço de Estacionamento Sim'
    expect(page).to have_content 'Atende a Endereço Indicado por Cliente Sim'
  end

  it 'and see error messages when a field fails its validation' do
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
    visit edit_event_type_path event_type

    within 'main form' do
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Mínimo de Pessoas', with: ''
      fill_in 'Máximo de Pessoas', with: ''
      fill_in 'Duração', with: ''
      fill_in 'Cardápio', with: ''
      click_on 'Atualizar Tipo de Evento'
    end

    expect(page).to have_content 'Preencha todos os campos corretamente ' \
                                 'para atualizar o tipo de evento.'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Mínimo de Pessoas não pode ficar em branco'
    expect(page).to have_content 'Máximo de Pessoas não pode ficar em branco'
    expect(page).to have_content 'Duração não pode ficar em branco'
    expect(page).to have_content 'Cardápio não pode ficar em branco'

    expect(page).to have_content 'Mínimo de Pessoas não é um número'
    expect(page).to have_content 'Máximo de Pessoas não é um número'
    expect(page).to have_content 'Duração não é um número'
  end

  it 'returning to his own buffet page if he tries to access another one ' \
     'event_type edition page' do
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
    visit edit_event_type_path second_event_type

    expect(current_path).to eq buffet_path first_buffet
    expect(page).to have_content 'Sabores Deliciosos Ltda.'
  end

  it "returning to buffet owner sign in page if he isn't signed in" do
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

    visit edit_event_type_path event_type

    expect(current_path).to eq new_buffet_owner_session_path
  end

  it "returning to home page if he is a client" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    client = Client
      .create! name: 'User',
               cpf: '11480076015',
               email: 'client@example.com',
               password: 'client-password'

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

    login_as client, scope: :client
    visit edit_event_type_path event_type

    expect(current_path).to eq root_path
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    login_as buffet_owner, scope: :buffet_owner
    visit edit_event_type_path 1

    expect(current_path).to eq new_buffet_path

    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end