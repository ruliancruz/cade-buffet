require 'rails_helper'

describe 'Client register order' do
  it 'from the buffet details page' do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    client = Client
      .create! name: 'João da Silva',
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
               serves_external_address: true,
               buffet: buffet

    PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    BasePrice
      .create! description: 'Meio de Semana',
               minimum: 10_000,
               additional_per_person: 250,
               extra_hour_value: 1_000,
               event_type: event_type

    login_as client, scope: :client
    visit event_type_path event_type
    click_on 'Fazer Pedido'

    within 'main form' do
      expect(page).to have_field 'Data do Evento'
      expect(page).to have_field 'Quantidade Estimada de Convidados'
      expect(page).to have_field 'Detalhes Adicionais'
      expect(page).to have_select 'Meio de Pagamento'

      expect(page).to have_field 'Endereço Desejado',
        with: 'Rua dos Sabores, 123 - Centro, Culinária City - BA, 12345-678'

      expect(page)
        .to have_content 'Altere se desejar que o evento ocorra em outro local'

      expect(page).to have_button 'Fazer Pedido'
    end
  end

  it "and doesn't find Fazer Pedido link if the event type doesn't have " \
     "base prices registered" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    client = Client
      .create! name: 'João da Silva',
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
               serves_external_address: true,
               buffet: buffet

    PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    login_as client, scope: :client
    visit event_type_path event_type

    expect(page).not_to have_link 'Fazer Pedido'

    expect(page).to have_content 'Este tipo de evento não pode ser ' \
      'contratado pois não possui preços-base cadastrados.'
  end

  it "and return to home page if the event type doesn't have base prices " \
     "registered" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    client = Client
      .create! name: 'João da Silva',
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
               serves_external_address: true,
               buffet: buffet

    PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    login_as client, scope: :client
    visit new_event_type_order_path event_type

    expect(current_path).to eq buffet_path buffet

    expect(page).to have_content 'Este tipo de evento não pode ser ' \
      'contratado pois não possui preços-base cadastrados'
  end

  it "and doesn't find Fazer Pedido link if the event type doesn't have " \
     "payment options registered" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    client = Client
      .create! name: 'João da Silva',
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
               serves_external_address: true,
               buffet: buffet

    BasePrice
      .create! description: 'Meio de Semana',
               minimum: 10_000,
               additional_per_person: 250,
               extra_hour_value: 1_000,
               event_type: event_type

    login_as client, scope: :client
    visit event_type_path event_type

    expect(page).not_to have_link 'Fazer Pedido'

    expect(page).to have_content 'Este tipo de evento não pode ser ' \
      'contratado pois o buffet não possui meios de pagamento cadastrados.'
  end

  it "and return to home page if the event type' buffet doesn't have " \
     "payment options registered" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    client = Client
      .create! name: 'João da Silva',
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
               serves_external_address: true,
               buffet: buffet

    BasePrice
      .create! description: 'Meio de Semana',
               minimum: 10_000,
               additional_per_person: 250,
               extra_hour_value: 1_000,
               event_type: event_type

    login_as client, scope: :client
    visit new_event_type_order_path event_type

    expect(current_path).to eq buffet_path buffet

    expect(page).to have_content 'Este tipo de evento não pode ser ' \
      'contratado pois o buffet não possui meios de pagamento cadastrados'
  end

  it "and don't see address field if the event type doesn't serves external " \
     "address" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    client = Client
      .create! name: 'João da Silva',
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

    BasePrice
      .create! description: 'Meio de Semana',
               minimum: 10_000,
               additional_per_person: 250,
               extra_hour_value: 1_000,
               event_type: event_type

    PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    login_as client, scope: :client
    visit event_type_path event_type
    click_on 'Fazer Pedido'

    within 'main form' do
      expect(page).not_to have_field 'Endereço Desejado'

      expect(page).not_to have_content 'Altere se desejar que o evento ' \
                                       'ocorra em outro local'
    end
  end

  it 'with success' do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    client = Client
      .create! name: 'João da Silva',
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
               serves_external_address: true,
               buffet: buffet

    PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    PaymentOption.create! name: 'Pix', installment_limit: 1, buffet: buffet

    BasePrice
      .create! description: 'Meio de Semana',
               minimum: 10_000,
               additional_per_person: 250,
               extra_hour_value: 1_000,
               event_type: event_type

    allow(SecureRandom).to receive(:alphanumeric).and_return 'S8baxMJn'

    login_as client, scope: :client
    visit new_event_type_order_path event_type

    within 'main form' do
      fill_in 'Data do Evento', with: I18n.localize(Date.current + 1.week)
      fill_in 'Quantidade Estimada de Convidados', with: '40'

      fill_in 'Detalhes Adicionais',
        with: 'Quero que inclua queijo suíço e vinho tinto.'

      select 'Pix', from: 'Meio de Pagamento'

      fill_in 'Endereço Desejado',
        with: 'Caminho dos bolos, 42 - Centro, Culinária City - BA'

      click_on 'Fazer Pedido'
    end

    expect(current_path).to eq order_path 1

    expect(page).to have_content 'Pedido enviado com sucesso! Aguarde a ' \
                                 'avaliação do buffet'

    expect(Order.first.code).to eq 'S8baxMJn'
    expect(page).to have_content 'Aguardando avaliação do buffet'
    expect(page).to have_content I18n.l(Date.current + 1.week)
    expect(page).to have_content '40'

    expect(page)
      .to have_content 'Caminho dos bolos, 42 - Centro, Culinária City - BA'

    expect(page).to have_content 'Pix'
    expect(page).to have_link 'Coquetel de Networking Empresarial'
    expect(page).to have_link 'Sabor & Arte Buffet'

    expect(page).not_to have_content 'Justificativa da Taxa Extra'
    expect(page).not_to have_content 'Justificativa do Desconto'
    expect(page).not_to have_content 'Preço Base Utilizado'
  end

  it "with success when the buffet doesn't serves external address" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    client = Client
      .create! name: 'João da Silva',
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
               serves_external_address: true,
               buffet: buffet

    BasePrice
      .create! description: 'Meio de Semana',
               minimum: 10_000,
               additional_per_person: 250,
               extra_hour_value: 1_000,
               event_type: event_type

    PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    PaymentOption.create! name: 'Pix', installment_limit: 1, buffet: buffet

    allow(SecureRandom).to receive(:alphanumeric).and_return 'S8baxMJn'

    login_as client, scope: :client
    visit new_event_type_order_path event_type

    within 'main form' do
      fill_in 'Data do Evento', with: I18n.localize(Date.current + 1.week)
      fill_in 'Quantidade Estimada de Convidados', with: '40'

      fill_in 'Detalhes Adicionais',
        with: 'Quero que inclua queijo suíço e vinho tinto.'

      select 'Pix', from: 'Meio de Pagamento'

      click_on 'Fazer Pedido'
    end

    expect(current_path).to eq order_path 1

    expect(page).to have_content 'Pedido enviado com sucesso! Aguarde a ' \
                                 'avaliação do buffet'

    expect(Order.first.code).to eq 'S8baxMJn'
    expect(page).to have_content 'Aguardando avaliação do buffet'
    expect(page).to have_content I18n.l(Date.current + 1.week)
    expect(page).to have_content '40'
    expect(page).to have_content 'Rua dos Sabores, 123 - Centro, Culinária City - BA'
    expect(page).to have_content 'Pix'
    expect(page).to have_link 'Coquetel de Networking Empresarial'
    expect(page).to have_link 'Sabor & Arte Buffet'

    expect(page).not_to have_content 'Justificativa da Taxa Extra'
    expect(page).not_to have_content 'Justificativa do Desconto'
    expect(page).not_to have_content 'Preço Base Utilizado'
  end

  it 'and see error messages when a field fails its validation' do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    client = Client
      .create! name: 'João da Silva',
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
               serves_external_address: true,
               buffet: buffet

    BasePrice
      .create! description: 'Meio de Semana',
               minimum: 10_000,
               additional_per_person: 250,
               extra_hour_value: 1_000,
               event_type: event_type

    PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    login_as client, scope: :client
    visit new_event_type_order_path event_type

    within 'main form' do
      click_on 'Fazer Pedido'
    end

    expect(page).to have_content 'Preencha todos os campos corretamente ' \
                                 'para fazer o pedido.'

    expect(page).to have_content 'Data do Evento não pode ficar em branco'

    expect(page).to have_content 'Quantidade Estimada de Convidados não ' \
                                 'pode ficar em branco'

    expect(page)
      .to have_content 'Quantidade Estimada de Convidados não é um número'
  end

  it "and returns to client sign in page if he isn't signed in" do
    visit new_event_type_order_path 1

    expect(current_path).to eq new_client_session_path
  end

  it "and returns to home page if he is a buffet owner" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    Buffet
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

    login_as buffet_owner, scope: :buffet_owner
    visit new_event_type_order_path 1

    expect(current_path).to eq root_path
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    login_as buffet_owner, scope: :buffet_owner
    visit new_event_type_order_path 1

    expect(current_path).to eq new_buffet_path

    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end