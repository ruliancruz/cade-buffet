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
                 description: 'Oferecemos uma experiência gastronômica única.',
                 buffet_owner: buffet_owner

      get "/api/v1/buffets/#{buffet.id}/event_types"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response).to eq []
    end
  end
end