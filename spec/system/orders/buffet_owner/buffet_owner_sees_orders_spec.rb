require 'rails_helper'

describe 'Buffet owner sees their orders' do
  it 'from the home page, ordered by date and grouped by status' do
    first_buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second_buffet_owner@example.com',
               password: 'second-password'

    client = Client
      .create! name: 'Client',
               cpf: '11480076015',
               email: 'client@example.com',
               password: 'client-password'

    first_buffet = Buffet
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
               district: 'Bairro Gourmet',
               city: 'Saborville',
               state: 'SP',
               cep: '87654321',
               buffet_owner: second_buffet_owner

    first_event_type = EventType
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
               buffet: first_buffet

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito',
               installment_limit: 12,
               buffet: first_buffet

    second_payment_option = PaymentOption
      .create! name: 'Pix', installment_limit: 1, buffet: second_buffet

    first_base_price = BasePrice
      .create! description: 'Meio de Semana',
               minimum: 10_000,
               additional_per_person: 250,
               extra_hour_value: 1_000,
               event_type: first_event_type

    second_base_price = BasePrice
      .create! description: 'Final de Semana',
               minimum: 14_000,
               additional_per_person: 300,
               extra_hour_value: 1_500,
               event_type: second_event_type

    first_order = Order
      .create! date: I18n.localize(Date.current + 2.week),
               attendees: 40,
               details: 'Quero que inclua queijo suíço e vinho tinto.',
               address: second_buffet.full_address,
               status: :waiting_for_evaluation,
               payment_option: second_payment_option,
               event_type: first_event_type,
               client: client

    second_order = Order
      .create! date: I18n.localize(Date.current + 3.week),
               attendees: 30,
               details: 'Quero que inclua coxinhas e pasteis.',
               address: first_buffet.full_address,
               status: :waiting_for_evaluation,
               payment_option: payment_option,
               event_type: second_event_type,
               client: client

    third_order = Order
      .create! date: I18n.localize(Date.current + 1.week),
               attendees: 28,
               details: 'Quero que inclua só coxinhas.',
               address: first_buffet.full_address,
               status: :waiting_for_evaluation,
               payment_option: payment_option,
               event_type: second_event_type,
               client: client

    fourth_order = Order
      .create! date: I18n.localize(Date.current + 12.week),
               attendees: 56,
               details: 'Quero que inclua só coxinhas.',
               address: first_buffet.full_address,
               status: :approved_by_buffet,
               event_type: second_event_type,
               client: client,
               payment_option: payment_option,
               base_price: second_base_price,
               expiration_date: I18n.localize(Date.current + 11.week),
               price_adjustment: -500,
               price_adjustment_description: 'Promoção'

    fifth_order = Order
      .create! date: I18n.localize(Date.current + 11.week),
               attendees: 48,
               details: 'Quero que inclua só coxinhas.',
               address: first_buffet.full_address,
               status: :approved_by_buffet,
               event_type: second_event_type,
               client: client,
               payment_option: payment_option,
               base_price: second_base_price,
               expiration_date: I18n.localize(Date.current + 10.week),
               price_adjustment: -500,
               price_adjustment_description: 'Promoção'

    sixth_order = Order
      .create! date: I18n.localize(Date.current + 10.week),
               attendees: 32,
               details: 'Quero que inclua só coxinhas.',
               address: second_buffet.full_address,
               status: :approved_by_buffet,
               event_type: first_event_type,
               client: client,
               payment_option: second_payment_option,
               base_price: first_base_price,
               expiration_date: I18n.localize(Date.current + 9.week),
               price_adjustment: -500,
               price_adjustment_description: 'Promoção'

    seventh_order = Order
      .create! date: I18n.localize(Date.current + 8.week),
               attendees: 24,
               details: 'Quero que inclua só coxinhas.',
               address: first_buffet.full_address,
               status: :canceled,
               event_type: second_event_type,
               client: client,
               payment_option: payment_option,
               base_price: second_base_price,
               expiration_date: I18n.localize(Date.current + 7.week),
               price_adjustment: -500,
               price_adjustment_description: 'Promoção'

    eighth_order = Order
      .create! date: I18n.localize(Date.current + 9.week),
               attendees: 16,
               details: 'Quero que inclua só coxinhas.',
               address: second_buffet.full_address,
               status: :canceled,
               event_type: first_event_type,
               client: client,
               payment_option: second_payment_option,
               base_price: first_base_price,
               expiration_date: I18n.localize(Date.current + 8.week),
               price_adjustment: -500,
               price_adjustment_description: 'Promoção'

    ninth_order = Order
      .create! date: I18n.localize(Date.current + 7.week),
               attendees: 23,
               details: 'Quero que inclua só coxinhas.',
               address: first_buffet.full_address,
               status: :canceled,
               event_type: second_event_type,
               client: client,
               payment_option: payment_option,
               base_price: second_base_price,
               expiration_date: I18n.localize(Date.current + 6.week),
               price_adjustment: -500,
               price_adjustment_description: 'Promoção'

    tenth_order = Order
      .create! date: I18n.localize(Date.current + 6.week),
               attendees: 35,
               details: 'Quero que inclua só coxinhas.',
               address: second_buffet.full_address,
               status: :confirmed,
               event_type: first_event_type,
               client: client,
               payment_option: second_payment_option,
               base_price: first_base_price,
               expiration_date: I18n.localize(Date.current + 5.week),
               price_adjustment: -500,
               price_adjustment_description: 'Promoção'

    eleventh_order = Order
      .create! date: I18n.localize(Date.current + 5.week),
               attendees: 30,
               details: 'Quero que inclua só coxinhas.',
               address: first_buffet.full_address,
               status: :confirmed,
               event_type: second_event_type,
               client: client,
               payment_option: payment_option,
               base_price: second_base_price,
               expiration_date: I18n.localize(Date.current + 4.week),
               price_adjustment: -500,
               price_adjustment_description: 'Promoção'

    twelfth_order = Order
      .create! date: I18n.localize(Date.current + 4.week),
               attendees: 25,
               details: 'Quero que inclua só coxinhas.',
               address: first_buffet.full_address,
               status: :confirmed,
               event_type: second_event_type,
               client: client,
               payment_option: payment_option,
               base_price: second_base_price,
               expiration_date: I18n.localize(Date.current + 3.week),
               price_adjustment: -500,
               price_adjustment_description: 'Promoção'

    login_as first_buffet_owner, scope: :buffet_owner
    visit root_path
    click_on 'Pedidos'

    expect(current_path).to eq orders_path

    within 'main section:nth(1)' do
      within 'h2:nth(1)' do
        expect(page).to have_content 'Pedidos Aguardando Avaliação'
      end

      within 'dl dt:nth(1)' do
        expect(page).to have_link third_order.code
      end

      within 'dl dd:nth(1)' do
        expect(page).to have_content I18n.localize(Date.current + 1.week)
      end

      within 'dl dt:nth(2)' do
        expect(page).to have_link second_order.code
      end

      within 'dl dd:nth(2)' do
        expect(page).to have_content I18n.localize(Date.current + 3.week)
      end

      expect(page).not_to have_link first_order.code
      expect(page).not_to have_content I18n.localize(Date.current + 2.week)
    end

    within 'main section:nth(2)' do
      within 'h2:nth(1)' do
        expect(page)
          .to have_content 'Pedidos Aguardando Confirmação do Cliente'
      end

      within 'dl dt:nth(1)' do
        expect(page).to have_link fifth_order.code
      end

      within 'dl dd:nth(1)' do
        expect(page).to have_content I18n.localize(Date.current + 11.week)
      end

      within 'dl dt:nth(2)' do
        expect(page).to have_link fourth_order.code
      end

      within 'dl dd:nth(2)' do
        expect(page).to have_content I18n.localize(Date.current + 12.week)
      end

      expect(page).not_to have_link sixth_order.code
      expect(page).not_to have_content I18n.localize(Date.current + 10.week)
    end

    within 'main section:nth(3)' do
      within 'h2:nth(1)' do
        expect(page).to have_content 'Pedidos Confirmados'
      end

      within 'dl dt:nth(1)' do
        expect(page).to have_link twelfth_order.code
      end

      within 'dl dd:nth(1)' do
        expect(page).to have_content I18n.localize(Date.current + 4.week)
      end

      within 'dl dt:nth(2)' do
        expect(page).to have_link eleventh_order.code
      end

      within 'dl dd:nth(2)' do
        expect(page).to have_content I18n.localize(Date.current + 5.week)
      end

      expect(page).not_to have_link tenth_order.code
      expect(page).not_to have_content I18n.localize(Date.current + 6.week)
    end

    within 'main section:nth(4)' do
      within 'h2:nth(1)' do
        expect(page).to have_content 'Pedidos Cancelados'
      end

      within 'dl dt:nth(1)' do
        expect(page).to have_link ninth_order.code
      end

      within 'dl dd:nth(1)' do
        expect(page).to have_content I18n.localize(Date.current + 7.week)
      end

      within 'dl dt:nth(2)' do
        expect(page).to have_link seventh_order.code
      end

      within 'dl dd:nth(2)' do
        expect(page).to have_content I18n.localize(Date.current + 8.week)
      end

      expect(page).not_to have_link eighth_order.code
      expect(page).not_to have_content I18n.localize(Date.current + 9.week)
    end
  end

  it 'and see a message if he has no orders' do
    first_buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second_buffet_owner@example.com',
               password: 'second-password'

    client = Client
      .create! name: 'Client',
               cpf: '11480076015',
               email: 'client@example.com',
               password: 'client-password'

    buffet = Buffet
      .create! corporate_name: 'Sabores Deliciosos Ltda.',
               brand_name: 'Chef & Cia Buffet',
               cnpj: '96577377000187',
               phone: '9887654321',
               address: 'Avenida das Delícias, 456',
               district: 'Bairro Gourmet',
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
               buffet: buffet

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    BasePrice
      .create! description: 'Meio de Semana',
               minimum: 10_000,
               additional_per_person: 250,
               extra_hour_value: 1_000,
               event_type: event_type

    Order
      .create! date: I18n.localize(Date.current + 2.week),
               attendees: 40,
               details: 'Quero que inclua queijo suíço e vinho tinto.',
               address: buffet.full_address,
               status: :waiting_for_evaluation,
               payment_option: payment_option,
               event_type: event_type,
               client: client

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

    login_as first_buffet_owner, scope: :buffet_owner
    visit orders_path

    expect(page).to have_content 'Você ainda não tem pedidos.'
  end
end