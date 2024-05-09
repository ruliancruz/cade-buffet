require 'rails_helper'

describe 'buffet owner sees their orders' do
  it 'from the home page, ordered by date and grouped by status' do
    buffet_owner = BuffetOwner.create! email: 'user@example.com', password: 'password'

    another_buffet_owner = BuffetOwner.create! email: 'another.user@example.com',
                                               password: 'another-password'

    client = Client.create! name: 'Client',
                            cpf: '11480076015',
                            email: 'client@example.com',
                            password: 'client-password'

    buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                            brand_name: 'Sabor & Arte Buffet',
                            cnpj: '34340299000145',
                            phone: '7531274464',
                            address: 'Rua dos Sabores, 123',
                            district: 'Centro',
                            city: 'Culinária City',
                            state: 'BA',
                            cep: '12345678',
                            buffet_owner: buffet_owner

    another_buffet = Buffet.create! corporate_name: 'Sabores Deliciosos Ltda.',
                                    brand_name: 'Chef & Cia Buffet',
                                    cnpj: '96577377000187',
                                    phone: '9887654321',
                                    address: 'Avenida das Delícias, 456',
                                    district: 'Bairro Gourmet',
                                    city: 'Saborville',
                                    state: 'SP',
                                    cep: '87654321',
                                    buffet_owner: another_buffet_owner

    event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                   description: 'Um evento descontraído.',
                                   minimum_attendees: 20,
                                   maximum_attendees: 50,
                                   duration: 120,
                                   menu: 'Seleção de queijos, frutas e vinhos',
                                   provides_alcohol_drinks: true,
                                   provides_decoration: false,
                                   provides_parking_service: false,
                                   serves_external_address: true,
                                   buffet: another_buffet

    another_event_type = EventType.create! name: 'Festa de Aniversário infantil',
                                           description: 'Um evento muito legal.',
                                           minimum_attendees: 10,
                                           maximum_attendees: 40,
                                           duration: 80,
                                           menu: 'Bolos, salgados, sucos e refrigerantes',
                                           provides_alcohol_drinks: false,
                                           provides_decoration: true,
                                           provides_parking_service: false,
                                           serves_external_address: true,
                                           buffet: buffet

    payment_option = PaymentOption.create! name: 'Cartão de Crédito',
                                           installment_limit: 12,
                                           buffet: buffet

    another_payment_option = PaymentOption.create! name: 'Pix',
                                                   installment_limit: 1,
                                                   buffet: another_buffet

    base_price = BasePrice.create! description: 'Meio de Semana',
                      minimum: 10_000,
                      additional_per_person: 250,
                      extra_hour_value: 1_000,
                      event_type: event_type

    another_base_price = BasePrice.create! description: 'Final de Semana',
                                           minimum: 14_000,
                                           additional_per_person: 300,
                                           extra_hour_value: 1_500,
                                           event_type: another_event_type

    first_order = Order.new date: I18n.localize(Date.current + 2.week),
                            attendees: 40,
                            details: 'Quero que inclua queijo suíço e vinho tinto.',
                            address: buffet.full_address,
                            status: :waiting_for_evaluation,
                            payment_option: another_payment_option,
                            event_type: event_type,
                            client: client

    first_order.generate_code
    first_order.save!

    second_order = Order.new date: I18n.localize(Date.current + 3.week),
                             attendees: 30,
                             details: 'Quero que inclua coxinhas e pasteis.',
                             address: buffet.full_address,
                             status: :waiting_for_evaluation,
                             payment_option: payment_option,
                             event_type: another_event_type,
                             client: client

    second_order.generate_code
    second_order.save!

    third_order = Order.new date: I18n.localize(Date.current + 1.week),
                            attendees: 28,
                            details: 'Quero que inclua só coxinhas.',
                            address: buffet.full_address,
                            status: :waiting_for_evaluation,
                            payment_option: payment_option,
                            event_type: another_event_type,
                            client: client

    third_order.generate_code
    third_order.save!

    fourth_order = Order.new date: I18n.localize(Date.current + 12.week),
                             attendees: 56,
                             details: 'Quero que inclua só coxinhas.',
                             address: buffet.full_address,
                             status: :approved_by_buffet,
                             event_type: another_event_type,
                             client: client,
                             payment_option: payment_option,
                             base_price: another_base_price,
                             expiration_date: I18n.localize(Date.current + 11.week),
                             price_adjustment: -500,
                             price_adjustment_description: 'Promoção'

    fourth_order.generate_code
    fourth_order.save!

    fifth_order = Order.new date: I18n.localize(Date.current + 11.week),
                            attendees: 48,
                            details: 'Quero que inclua só coxinhas.',
                            address: buffet.full_address,
                            status: :approved_by_buffet,
                            event_type: another_event_type,
                            client: client,
                            payment_option: payment_option,
                            base_price: another_base_price,
                            expiration_date: I18n.localize(Date.current + 10.week),
                            price_adjustment: -500,
                            price_adjustment_description: 'Promoção'

    fifth_order.generate_code
    fifth_order.save!

    sixth_order = Order.new date: I18n.localize(Date.current + 10.week),
                            attendees: 32,
                            details: 'Quero que inclua só coxinhas.',
                            address: buffet.full_address,
                            status: :approved_by_buffet,
                            event_type: event_type,
                            client: client,
                            payment_option: another_payment_option,
                            base_price: base_price,
                            expiration_date: I18n.localize(Date.current + 9.week),
                            price_adjustment: -500,
                            price_adjustment_description: 'Promoção'

    sixth_order.generate_code
    sixth_order.save!

    seventh_order = Order.new date: I18n.localize(Date.current + 8.week),
                              attendees: 24,
                              details: 'Quero que inclua só coxinhas.',
                              address: buffet.full_address,
                              status: :canceled,
                              event_type: another_event_type,
                              client: client,
                              payment_option: payment_option,
                              base_price: another_base_price,
                              expiration_date: I18n.localize(Date.current + 7.week),
                              price_adjustment: -500,
                              price_adjustment_description: 'Promoção'

    seventh_order.generate_code
    seventh_order.save!

    eighth_order = Order.new date: I18n.localize(Date.current + 9.week),
                             attendees: 16,
                             details: 'Quero que inclua só coxinhas.',
                             address: buffet.full_address,
                             status: :canceled,
                             event_type: event_type,
                             client: client,
                             payment_option: another_payment_option,
                             base_price: base_price,
                             expiration_date: I18n.localize(Date.current + 8.week),
                             price_adjustment: -500,
                             price_adjustment_description: 'Promoção'

    eighth_order.generate_code
    eighth_order.save!

    ninth_order = Order.new date: I18n.localize(Date.current + 7.week),
                            attendees: 23,
                            details: 'Quero que inclua só coxinhas.',
                            address: buffet.full_address,
                            status: :canceled,
                            event_type: another_event_type,
                            client: client,
                            payment_option: payment_option,
                            base_price: another_base_price,
                            expiration_date: I18n.localize(Date.current + 6.week),
                            price_adjustment: -500,
                            price_adjustment_description: 'Promoção'

    ninth_order.generate_code
    ninth_order.save!

    tenth_order = Order.new date: I18n.localize(Date.current + 6.week),
                            attendees: 35,
                            details: 'Quero que inclua só coxinhas.',
                            address: buffet.full_address,
                            status: :confirmed,
                            event_type: event_type,
                            client: client,
                            payment_option: another_payment_option,
                            base_price: base_price,
                            expiration_date: I18n.localize(Date.current + 5.week),
                            price_adjustment: -500,
                            price_adjustment_description: 'Promoção'

    tenth_order.generate_code
    tenth_order.save!

    eleventh_order = Order.new date: I18n.localize(Date.current + 5.week),
                               attendees: 30,
                               details: 'Quero que inclua só coxinhas.',
                               address: buffet.full_address,
                               status: :confirmed,
                               event_type: another_event_type,
                               client: client,
                               payment_option: payment_option,
                               base_price: another_base_price,
                               expiration_date: I18n.localize(Date.current + 4.week),
                               price_adjustment: -500,
                               price_adjustment_description: 'Promoção'

    eleventh_order.generate_code
    eleventh_order.save!

    twelfth_order = Order.new date: I18n.localize(Date.current + 4.week),
                              attendees: 25,
                              details: 'Quero que inclua só coxinhas.',
                              address: buffet.full_address,
                              status: :confirmed,
                              event_type: another_event_type,
                              client: client,
                              payment_option: payment_option,
                              base_price: another_base_price,
                              expiration_date: I18n.localize(Date.current + 3.week),
                              price_adjustment: -500,
                              price_adjustment_description: 'Promoção'

    twelfth_order.generate_code
    twelfth_order.save!

    login_as buffet_owner, scope: :buffet_owner
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
        expect(page).to have_content 'Pedidos Aguardando Confirmação do Cliente'
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
    buffet_owner = BuffetOwner.create! email: 'user@example.com', password: 'password'

    Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
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
    visit orders_path

    expect(page).to have_content 'Você ainda não tem pedidos.'
  end
end