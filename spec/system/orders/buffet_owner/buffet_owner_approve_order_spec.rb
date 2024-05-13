require 'rails_helper'

describe 'Buffet owner approves order' do
  it 'from the order page' do
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

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

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

    order = Order
      .create! date: I18n.localize(Date.current + 2.week),
               attendees: 40,
               details: 'Quero que inclua queijo suíço e vinho tinto.',
               address: buffet.full_address,
               status: :waiting_for_evaluation,
               payment_option: payment_option,
               event_type: event_type,
               client: client

    login_as buffet_owner, scope: :buffet_owner
    visit order_path order
    click_on 'Aprovar Pedido'

    expect(current_path).to eq edit_order_path order

    expect(page).to have_content order.code

    within 'main form' do
      expect(page).to have_content 'Meio de Semana'
      expect(page).to have_content 'R$15.000,00'
      expect(page).to have_content 'Final de Semana'
      expect(page).to have_content 'R$20.000,00'
      expect(page).to have_select 'Preço-base'
      expect(page).to have_field 'Ajuste de Preço'

      expect(page)
        .to have_content 'insira um número negativo para conceder desconto'

      expect(page).to have_field 'Justificativa do Ajuste de Preço'

      expect(page).to have_field 'Data de Validade do Preço',
        with: I18n.localize(Date.current + 2.week)

      expect(page).to have_select 'Meio de Pagamento',
        with_selected: 'Cartão de Crédito'

      expect(page).to have_button 'Aprovar Pedido'
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

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    PaymentOption.create! name: 'Pix', installment_limit: 1, buffet: buffet

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

    order = Order
      .create! date: I18n.localize(Date.current + 2.week),
               attendees: 40,
               details: 'Quero que inclua queijo suíço e vinho tinto.',
               address: buffet.full_address,
               status: :waiting_for_evaluation,
               payment_option: payment_option,
               event_type: event_type,
               client: client

    login_as buffet_owner, scope: :buffet_owner
    visit edit_order_path order

    within 'main form' do
      select 'Meio de Semana', from: 'Preço-base'
      fill_in 'Ajuste de Preço', with: '-500'
      fill_in 'Justificativa do Ajuste de Preço', with: 'Promoção especial!'

      fill_in 'Data de Validade do Preço',
        with: I18n.localize(Date.current + 1.week)

      select 'Pix', from: 'Meio de Pagamento'

      click_on 'Aprovar Pedido'
    end

    expect(current_path).to eq order_path order

    within 'main' do
      expect(page).to have_content 'Pedido aprovado pelo buffet, aguardando ' \
                                   'confirmação do cliente'

      expect(page).to have_content 'Meio de Semana'
      expect(page).to have_content 'R$14.500,00'
      expect(page).to have_content 'R$500,00'
      expect(page).to have_content 'Promoção especial!'
      expect(page).to have_content I18n.localize(Date.current + 1.week)
      expect(page).to have_content 'Pix'
      expect(page).not_to have_content 'Cartão de Crédito'
    end
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

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    order = Order
      .create! date: I18n.localize(Date.current + 2.week),
               attendees: 40,
               details: 'Quero que inclua queijo suíço e vinho tinto.',
               address: buffet.full_address,
               status: :waiting_for_evaluation,
               payment_option: payment_option,
               event_type: event_type,
               client: client

    login_as buffet_owner, scope: :buffet_owner
    visit edit_order_path order

    within 'main form' do
      fill_in 'Data de Validade do Preço', with: ''
      click_on 'Aprovar Pedido'
    end

    expect(page).to have_content 'Preencha todos os campos corretamente ' \
                                 'para aprovar o pedido.'

    expect(page).to have_content 'Preço-base não pode ficar em branco'

    expect(page)
      .to have_content 'Data de Validade do Preço não pode ficar em branco'
  end

  it 'returning to home page if he tries to access another one order ' \
     'approval page' do
    first_buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second_buffet_owner@example.com',
               password: 'second-password'

    client = Client
      .create! name: 'João da Silva',
               cpf: '11480076015',
               email: 'client@example.com',
               password: 'client-password'

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
               buffet_owner: first_buffet_owner

    second_buffet = Buffet
      .create! corporate_name: 'Sabores Deliciosos Ltda.',
               brand_name: 'Chef & Cia Buffet',
               cnpj: '96577377000187',
               phone: '9887654321',
               address: 'Avenida das Delícias, 456',
               district: 'Gourmet',
               city: 'Saborville',
               state: 'SP',
               cep: '87654321',
               buffet_owner: second_buffet_owner

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
               buffet: second_buffet

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito',
               installment_limit: 12,
               buffet: second_buffet

    BasePrice
      .create! description: 'Meio de Semana',
               minimum: 10_000,
               additional_per_person: 250,
               extra_hour_value: 1_000,
               event_type: event_type

    order = Order
      .create! date: I18n.localize(Date.current + 2.week),
               attendees: 40,
               details: 'Quero que inclua queijo suíço e vinho tinto.',
               address: second_buffet.full_address,
               status: :waiting_for_evaluation,
               payment_option: payment_option,
               event_type: event_type,
               client: client

    login_as first_buffet_owner, scope: :buffet_owner
    visit edit_order_path order

    expect(current_path).to eq root_path

    expect(page)
      .to have_content 'Você não pode aprovar pedidos de outros buffets'
  end

  it "returning to client sign in page if he isn't signed in" do
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

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

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

    order = Order
      .create! date: I18n.localize(Date.current + 2.week),
               attendees: 40,
               details: 'Quero que inclua queijo suíço e vinho tinto.',
               address: buffet.full_address,
               status: :waiting_for_evaluation,
               payment_option: payment_option,
               event_type: event_type,
               client: client

    visit edit_order_path order

    expect(current_path).to eq new_client_session_path
  end

  it "not seeing approval button if he is a client" do
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

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

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

    order = Order
      .create! date: I18n.localize(Date.current + 2.week),
               attendees: 40,
               details: 'Quero que inclua queijo suíço e vinho tinto.',
               address: buffet.full_address,
               status: :waiting_for_evaluation,
               payment_option: payment_option,
               event_type: event_type,
               client: client

    login_as client, scope: :client
    visit order_path order

    expect(page).not_to have_link 'Aprovar Pedido'
  end

  it "returning to order page if he is a client" do
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

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

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

    order = Order
      .create! date: I18n.localize(Date.current + 2.week),
               attendees: 40,
               details: 'Quero que inclua queijo suíço e vinho tinto.',
               address: buffet.full_address,
               status: :waiting_for_evaluation,
               payment_option: payment_option,
               event_type: event_type,
               client: client

    login_as client, scope: :client
    visit edit_order_path order

    expect(current_path).to eq order_path order
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    login_as buffet_owner, scope: :buffet_owner
    visit edit_order_path 1

    expect(current_path).to eq new_buffet_path

    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end