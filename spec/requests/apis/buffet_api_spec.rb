require 'rails_helper'

describe 'Buffet API' do
  context 'GET /api/v1/buffet/1' do
    it 'success' do
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

      get "/api/v1/buffets/#{buffet.id}"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response['brand_name']).to eq 'Sabor & Arte Buffet'
      expect(json_response['phone']).to eq '7531274464'
      expect(json_response['address']).to eq 'Rua dos Sabores, 123'
      expect(json_response['district']).to eq 'Centro'
      expect(json_response['city']).to eq 'Culinária City'
      expect(json_response['state']).to eq 'BA'
      expect(json_response['cep']).to eq '12345678'

      expect(json_response['description'])
        .to eq 'Oferecemos uma experiência gastronômica única.'

      expect(json_response.keys).not_to include 'corporate_name'
      expect(json_response.keys).not_to include 'cnpj'
      expect(json_response.keys).not_to include 'created_at'
      expect(json_response.keys).not_to include 'updated_at'
    end

    it "fails if the buffet isn't found" do
      get "/api/v1/buffets/9999999"

      expect(response.status).to eq 404
    end
  end

  context 'GET /api/v1/buffets' do
    it 'success' do
      first_buffet_owner = BuffetOwner
        .create! email: 'buffet_owner@example.com', password: 'password'

      second_buffet_owner = BuffetOwner
        .create! email: 'second_buffet_owner@example.com',
                 password: 'second-password'

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
                 description: 'Oferecemos uma experiência gastronômica única.',
                 buffet_owner: first_buffet_owner

      Buffet
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

      get "/api/v1/buffets"

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      puts json_response.inspect

      expect(json_response.length).to eq 2
      expect(json_response[0]['brand_name']).to eq 'Sabor & Arte Buffet'
      expect(json_response[0]['phone']).to eq '7531274464'
      expect(json_response[0]['address']).to eq 'Rua dos Sabores, 123'
      expect(json_response[0]['district']).to eq 'Centro'
      expect(json_response[0]['city']).to eq 'Culinária City'
      expect(json_response[0]['state']).to eq 'BA'
      expect(json_response[0]['cep']).to eq '12345678'

      expect(json_response[0]['description'])
        .to eq 'Oferecemos uma experiência gastronômica única.'

      expect(json_response[1]['brand_name']).to eq 'Chef & Cia Buffet'
      expect(json_response[1]['phone']).to eq '9887654321'
      expect(json_response[1]['address']).to eq 'Avenida das Delícias, 456'
      expect(json_response[1]['district']).to eq 'Bairro Gourmet'
      expect(json_response[1]['city']).to eq 'Saborville'
      expect(json_response[1]['state']).to eq 'SP'
      expect(json_response[1]['cep']).to eq '87654321'
    end
  end
end