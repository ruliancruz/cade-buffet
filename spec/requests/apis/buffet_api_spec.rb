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

    it "and fails with the buffet isn't found" do
      get "/api/v1/buffets/9999999"

      expect(response.status).to eq 404
    end
  end
end