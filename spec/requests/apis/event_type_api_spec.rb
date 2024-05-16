require 'rails_helper'

describe 'Buffet API' do
  context 'GET /api/v1/buffets/1/event_types' do
    it 'success' do
      first_buffet_owner = BuffetOwner
        .create! email: 'buffet_owner@example.com', password: 'password'

      second_buffet_owner = BuffetOwner
        .create! email: 'second_buffet_owner@example.com',
                 password: 'second-password'

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
                 description: 'Oferecemos uma experiência gastronômica única.',
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

      EventType
        .create! name: 'Coquetel de Networking Empresarial',
                 description: 'Um evento descontraído.',
                 minimum_attendees: 20,
                 maximum_attendees: 50,
                 duration: 120,
                 menu: 'Seleção de queijos, frutas e vinhos.',
                 provides_alcohol_drinks: true,
                 provides_decoration: false,
                 provides_parking_service: false,
                 serves_external_address: false,
                 buffet: first_buffet

      EventType
        .create! name: 'Festa de Aniversário infantil',
                 description: 'Um evento muito legal.',
                 minimum_attendees: 10,
                 maximum_attendees: 40,
                 duration: 80,
                 menu: 'Bolos, salgados, sucos e refrigerantes.',
                 provides_alcohol_drinks: false,
                 provides_decoration: true,
                 provides_parking_service: false,
                 serves_external_address: true,
                 buffet: second_buffet

      EventType
        .create! name: 'Festa de Casamento',
                 description: 'Um evento fabuloso!',
                 minimum_attendees: 30,
                 maximum_attendees: 80,
                 duration: 150,
                 menu: 'Bolo gigante, doces, salgados, vinho e champagne.',
                 provides_alcohol_drinks: true,
                 provides_decoration: true,
                 provides_parking_service: true,
                 serves_external_address: false,
                 buffet: second_buffet

      get "/api/v1/buffets/#{second_buffet.id}/event_types"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response.length).to eq 2

      expect(json_response[0]['id'].nil?).to be false
      expect(json_response[0]['name']).to eq 'Festa de Aniversário infantil'
      expect(json_response[0]['description']).to eq 'Um evento muito legal.'
      expect(json_response[0]['minimum_attendees']).to eq 10
      expect(json_response[0]['maximum_attendees']).to eq 40
      expect(json_response[0]['duration']).to eq 80

      expect(json_response[0]['menu'])
        .to eq 'Bolos, salgados, sucos e refrigerantes.'

      expect(json_response[0]['provides_alcohol_drinks']).to eq 0
      expect(json_response[0]['provides_decoration']).to eq 1
      expect(json_response[0]['provides_parking_service']).to eq 0
      expect(json_response[0]['serves_external_address']).to eq 1

      expect(json_response[1]['id'].nil?).to be false
      expect(json_response[1]['name']).to eq 'Festa de Casamento'
      expect(json_response[1]['description']).to eq 'Um evento fabuloso!'
      expect(json_response[1]['minimum_attendees']).to eq 30
      expect(json_response[1]['maximum_attendees']).to eq 80
      expect(json_response[1]['duration']).to eq 150

      expect(json_response[1]['menu'])
        .to eq 'Bolo gigante, doces, salgados, vinho e champagne.'

      expect(json_response[1]['provides_alcohol_drinks']).to eq 1
      expect(json_response[1]['provides_decoration']).to eq 1
      expect(json_response[1]['provides_parking_service']).to eq 1
      expect(json_response[1]['serves_external_address']).to eq 0

      expect(json_response.include? 'Coquetel de Networking Empresarial')
        .to be false

      expect(json_response.include? 'Um evento descontraído.').to be false

      expect(json_response.include? 'Seleção de queijos, frutas e vinhos.')
        .to be false
    end

    it "returns empty if there isn't registered event types in this buffet" do
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

      get "/api/v1/buffets/#{buffet.id}/event_types"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response).to eq []
    end
  end

  context 'GET /api/v1/event_types/1?date=dd/mm/yyyy&attendee_quantity=40' do
    it 'success' do
      buffet_owner = BuffetOwner
        .create! email: 'buffet_owner@example.com', password: 'password'

      client = Client
        .create! name: 'Client',
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

      first_event_type = EventType
        .create! name: 'Coquetel de Networking Empresarial',
                 description: 'Um evento descontraído.',
                 minimum_attendees: 20,
                 maximum_attendees: 50,
                 duration: 120,
                 menu: 'Seleção de queijos, frutas e vinhos.',
                 provides_alcohol_drinks: true,
                 provides_decoration: false,
                 provides_parking_service: false,
                 serves_external_address: false,
                 buffet: buffet

      EventType
        .create! name: 'Festa de Aniversário infantil',
                 description: 'Um evento muito legal.',
                 minimum_attendees: 10,
                 maximum_attendees: 40,
                 duration: 80,
                 menu: 'Bolos, salgados, sucos e refrigerantes.',
                 provides_alcohol_drinks: false,
                 provides_decoration: true,
                 provides_parking_service: false,
                 serves_external_address: true,
                 buffet: buffet

      first_base_price = BasePrice
        .create! description: 'Meio de Semana',
                 minimum: 10_000,
                 additional_per_person: 250,
                 extra_hour_value: 1_000,
                 event_type: first_event_type

      BasePrice
        .create! description: 'Final de Semana',
                 minimum: 14_000,
                 additional_per_person: 300,
                 extra_hour_value: 1_500,
                 event_type: first_event_type

      payment_option = PaymentOption
        .create! name: 'Cartão de Crédito',
                 installment_limit: 12,
                 buffet: buffet

      Order
        .create! date: I18n.localize(Date.current + 6.days),
                 attendees: 40,
                 details: 'Quero que inclua queijo suíço e vinho tinto.',
                 address: buffet.full_address,
                 expiration_date: I18n.localize(Date.current + 2.day),
                 status: :approved_by_buffet,
                 base_price: first_base_price,
                 payment_option: payment_option,
                 event_type: first_event_type,
                 client: client

      Order
        .create! date: I18n.localize(Date.current + 8.days),
                 attendees: 30,
                 details: 'Quero que inclua coxinhas e pasteis.',
                 address: buffet.full_address,
                 expiration_date: I18n.localize(Date.current + 4.day),
                 status: :confirmed,
                 base_price: first_base_price,
                 payment_option: payment_option,
                 event_type: first_event_type,
                 client: client

      Order
        .create! date: I18n.localize(Date.current + 1.week),
                 attendees: 28,
                 details: 'Quero que inclua só coxinhas.',
                 address: buffet.full_address,
                 status: :waiting_for_evaluation,
                 payment_option: payment_option,
                 event_type: first_event_type,
                 client: client

      get "/api/v1/event_types/#{first_event_type.id}" \
          "?date=#{Date.current + 1.week}&attendee_quantity=40"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response['available']).to eq true
      expect(json_response['preview_prices'][0]['description']).to eq 'Meio de Semana'
      expect(json_response['preview_prices'][0]['value']).to eq 15_000
      expect(json_response['preview_prices'][1]['description']).to eq 'Final de Semana'
      expect(json_response['preview_prices'][1]['value']).to eq 20_000
    end

    it "error message if buffet isn't available" do
      buffet_owner = BuffetOwner
        .create! email: 'buffet_owner@example.com', password: 'password'

      client = Client
        .create! name: 'Client',
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
                 menu: 'Seleção de queijos, frutas e vinhos.',
                 provides_alcohol_drinks: true,
                 provides_decoration: false,
                 provides_parking_service: false,
                 serves_external_address: false,
                 buffet: buffet

      payment_option = PaymentOption
        .create! name: 'Cartão de Crédito',
                 installment_limit: 12,
                 buffet: buffet

      base_price = BasePrice
        .create! description: 'Meio de Semana',
                 minimum: 10_000,
                 additional_per_person: 250,
                 extra_hour_value: 1_000,
                 event_type: event_type

      Order
        .create! date: I18n.localize(Date.current + 1.week),
                 attendees: 40,
                 details: 'Quero que inclua queijo suíço e vinho tinto.',
                 address: buffet.full_address,
                 expiration_date: I18n.localize(Date.current + 2.days),
                 status: :approved_by_buffet,
                 base_price: base_price,
                 payment_option: payment_option,
                 event_type: event_type,
                 client: client

      get "/api/v1/event_types/#{event_type.id}" \
          "?date=#{Date.current + 1.week}&attendee_quantity=40"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response['available']).to eq false
      expect(json_response['preview_prices']).to eq nil
      expect(json_response['message'])
        .to eq 'Erro! O Buffet não está disponível para esta data.'
    end

    it "error messages when query parameters is missing" do
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
                 menu: 'Seleção de queijos, frutas e vinhos.',
                 provides_alcohol_drinks: true,
                 provides_decoration: false,
                 provides_parking_service: false,
                 serves_external_address: false,
                 buffet: buffet

      get "/api/v1/event_types/#{event_type.id}"

      expect(response.status).to eq 422
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response['errors']
        .include? 'Data precisa ser informada.').to be true

      expect(json_response['errors']
        .include? 'Quantidade de Convidados precisa ser informada.').to be true
    end

    it "error message when query parameters is invalid" do
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
                 menu: 'Seleção de queijos, frutas e vinhos.',
                 provides_alcohol_drinks: true,
                 provides_decoration: false,
                 provides_parking_service: false,
                 serves_external_address: false,
                 buffet: buffet

      get "/api/v1/event_types/#{event_type.id}" \
          "?date=9712hd129&attendee_quantity=40.2"

      expect(response.status).to eq 422
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response['errors']
        .include? 'Quantidade de Convidados precisa ser um número inteiro.').to be true

      expect(json_response['errors']
        .include? 'Data precisa estar no formato yyyy-mm-dd.').to be true
    end

    it "error message when query parameters is invalid" do
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
                 menu: 'Seleção de queijos, frutas e vinhos.',
                 provides_alcohol_drinks: true,
                 provides_decoration: false,
                 provides_parking_service: false,
                 serves_external_address: false,
                 buffet: buffet

      get "/api/v1/event_types/#{event_type.id}" \
          "?date=20/05/2000&attendee_quantity=40"

      expect(response.status).to eq 422
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response['errors']
        .include? 'Data precisa ser atual ou futura.').to be true
    end

    it "fails if the event type isn't found" do
      get '/api/v1/event_types/9999999?date=dd/mm/yyyy&attendee_quantity=40'

      expect(response.status).to eq 404
    end
  end
end