require 'rails_helper'

describe 'Client sees messages on order page' do
  it 'ordered by descending datetime' do
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

    order = Order
      .new date: I18n.localize(Date.current + 2.week),
           attendees: 40,
           details: 'Quero que inclua queijo suíço e vinho tinto.',
           address: buffet.full_address,
           status: :waiting_for_evaluation,
           payment_option: payment_option,
           event_type: event_type,
           client: client

    order.generate_code
    order.save!

    first_message = Message
      .create! text: 'Nunc ut consectetur arcu.',
               datetime: DateTime.current,
               author: :client,
               order: order

    second_message = Message
      .create! text: 'Donec accumsan urna malesuada lorem molestie.',
               datetime: DateTime.current + 1.hour,
               author: :buffet,
               order: order

    third_message = Message
      .create! text: 'Proin at purus quis orci egestas egestas bibendum.',
               datetime: DateTime.current + 2.hours,
               author: :client,
               order: order

    login_as client, scope: :client
    visit order_path order

    within 'main section:last' do
      within 'h2' do
        expect(page).to have_content 'Mensagens'
      end

      within 'dl' do
        within 'dt:nth(1)' do
          expect(page).to have_content 'João da Silva'
        end

        within 'dd:nth(1)' do
          expect(page).to have_content 'Proin at purus quis orci egestas ' \
                                       'egestas bibendum.'
        end

        within 'dd:nth(2)' do
          expect(page)
            .to have_content (I18n.localize third_message.datetime.localtime)
            .slice(5..-1)
            .slice 0..-7
        end

        within 'dt:nth(2)' do
          expect(page).to have_content 'Sabor & Arte Buffet'
        end

        within 'dd:nth(3)' do
          expect(page)
            .to have_content 'Donec accumsan urna malesuada lorem molestie.'
        end

        within 'dd:nth(4)' do
          expect(page)
            .to have_content (I18n.localize second_message.datetime.localtime)
            .slice(5..-1)
            .slice 0..-7
        end

        within 'dt:nth(3)' do
          expect(page).to have_content 'João da Silva'
        end

        within 'dd:nth(5)' do
          expect(page).to have_content 'Nunc ut consectetur arcu.'
        end

        within 'dd:nth(6)' do
          expect(page)
            .to have_content (I18n.localize first_message.datetime.localtime)
            .slice(5..-1)
            .slice 0..-7
        end
      end
    end
  end

  it 'and see a information message if there is no messages in the order' do
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

    order = Order
      .new date: I18n.localize(Date.current + 2.week),
           attendees: 40,
           details: 'Quero que inclua queijo suíço e vinho tinto.',
           address: buffet.full_address,
           status: :waiting_for_evaluation,
           payment_option: payment_option,
           event_type: event_type,
           client: client

    order.generate_code
    order.save!

    login_as client, scope: :client
    visit order_path order

    within 'main section:last' do
      expect(page).to have_content 'Vocês ainda não enviaram mensagens'
    end
  end
end