require 'rails_helper'

RSpec.describe Buffet, type: :model do
  describe '#full_address' do
    it 'returns full address' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet.full_address).to eq 'Rua dos Sabores, 123 - Centro, Culinária City - BA, 12345-678'
    end
  end

  describe '#formatted_phone' do
    it 'returns formatted phone when phone is 10 characters long' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet.formatted_phone).to eq '(75) 3127-4464'
    end

    it 'returns formatted phone when phone is 11 characters long' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '75931274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet.formatted_phone).to eq '(75) 93127-4464'
    end
  end

  describe '#formatted_cnpj' do
    it 'returns formatted cnpj when phone is 10 characters long' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet.formatted_cnpj).to eq '12.345.678/0001-90'
    end
  end

  describe '#valid?' do
    it 'false when corporate name is blank' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: '',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when brand name is blank' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: '',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when address is blank' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: '',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when district is blank' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: '',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when city is blank' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: '',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when buffet owner is missing' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678'

      expect(buffet).not_to be_valid
    end

    it 'false when cnpj have less than 14 characters' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '1234567800019',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when cnpj have more than 14 characters' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '123456780001900',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when phone has less than 10 characters' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '753127446',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when phone has more than 11 characters' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '753127446400',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when state has less than 2 characters' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'B',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when state has more than 2 characters' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BAA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when cep has less than 8 characters' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '1234567',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it 'false when cep has more than 8 characters' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '123456789',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it "false when cnpj isn't a number" do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: 'text',
                          phone: '7531274464',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it "false when phone isn't a number" do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.new corporate_name: 'Delícias Gastronômicas Ltda.',
                          brand_name: 'Sabor & Arte Buffet',
                          cnpj: '12345678000190',
                          phone: 'text',
                          address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end

    it "false when cnpj isn't unique" do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                     brand_name: 'Sabor & Arte Buffet',
                     cnpj: '12345678000190',
                     phone: '7531274464',
                     address: 'Rua dos Sabores, 123',
                     district: 'Centro',
                     city: 'Culinária City',
                     state: 'BA',
                     cep: '12345678',
                     buffet_owner: user

      buffet = Buffet.new corporate_name: 'Sabores Deliciosos Ltda.',
                          brand_name: 'Chef & Cia Buffet',
                          cnpj: '12345678000190',
                          phone: '9887654321',
                          address: 'Avenida das Delícias, 456',
                          district: 'Bairro Gourmet',
                          city: 'Saborville',
                          state: 'SP',
                          cep: '87654321',
                          buffet_owner: user

      expect(buffet).not_to be_valid
    end
  end
end
