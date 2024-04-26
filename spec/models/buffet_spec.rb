require 'rails_helper'

RSpec.describe Buffet, type: :model do
  describe '#full_address' do
    it 'returns full address' do
      buffet = Buffet.new address: 'Rua dos Sabores, 123',
                          district: 'Centro',
                          city: 'Culinária City',
                          state: 'BA',
                          cep: '12345678'

      expect(buffet.full_address)
        .to eq 'Rua dos Sabores, 123 - Centro, Culinária City - BA, 12345-678'
    end
  end

  describe '#formatted_phone' do
    it 'returns formatted phone when phone is 10 characters long' do
      buffet = Buffet.new phone: '7531274464'

      expect(buffet.formatted_phone).to eq '(75) 3127-4464'
    end

    it 'returns formatted phone when phone is 11 characters long' do
      buffet = Buffet.new phone: '75931274464'

      expect(buffet.formatted_phone).to eq '(75) 93127-4464'
    end
  end

  describe '#formatted_cnpj' do
    it 'returns formatted cnpj when phone is 10 characters long' do
      buffet = Buffet.new cnpj: '12345678000190'

      expect(buffet.formatted_cnpj).to eq '12.345.678/0001-90'
    end
  end

  describe '#valid?' do
    it 'false when corporate name is blank' do
      buffet = Buffet.new corporate_name: ''

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Razão Social não pode ficar em branco').to be true
    end

    it 'false when brand name is blank' do
      buffet = Buffet.new brand_name: ''

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Nome Fantasia não pode ficar em branco').to be true
    end

    it 'false when cnpj is blank' do
      buffet = Buffet.new cnpj: ''

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CNPJ não pode ficar em branco').to be true
    end

    it 'false when phone is blank' do
      buffet = Buffet.new phone: ''

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Telefone não pode ficar em branco').to be true
    end

    it 'false when address is blank' do
      buffet = Buffet.new address: ''

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Endereço não pode ficar em branco').to be true
    end

    it 'false when district is blank' do
      buffet = Buffet.new district: ''

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Bairro não pode ficar em branco').to be true
    end

    it 'false when city is blank' do
      buffet = Buffet.new city: ''

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Cidade não pode ficar em branco').to be true
    end

    it 'false when state is blank' do
      buffet = Buffet.new state: ''

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Estado não pode ficar em branco').to be true
    end

    it 'false when cep is blank' do
      buffet = Buffet.new cep: ''

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CEP não pode ficar em branco').to be true
    end

    it 'false when buffet owner is missing' do
      buffet = Buffet.new

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Usuário é obrigatório(a)').to be true
    end

    it 'false when cnpj have less than 14 characters' do
      buffet = Buffet.new cnpj: '1234567890123'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CNPJ não possui o tamanho esperado (14 caracteres)').to be true
    end

    it 'false when cnpj have more than 14 characters' do
      buffet = Buffet.new cnpj: '123456789012345'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CNPJ não possui o tamanho esperado (14 caracteres)').to be true
    end

    it 'false when phone has less than 10 characters' do
      buffet = Buffet.new phone: '123456789'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Telefone é muito curto (mínimo: 10 caracteres)').to be true
    end

    it 'false when phone has more than 11 characters' do
      buffet = Buffet.new phone: '123456789012'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Telefone é muito longo (máximo: 11 caracteres)').to be true
    end

    it 'false when state has less than 2 characters' do
      buffet = Buffet.new state: 'B'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Estado não possui o tamanho esperado (2 caracteres)').to be true
    end

    it 'false when state has more than 2 characters' do
      buffet = Buffet.new state: 'BAA'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Estado não possui o tamanho esperado (2 caracteres)').to be true
    end

    it 'false when cep has less than 8 characters' do
      buffet = Buffet.new cep: '1234567'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CEP não possui o tamanho esperado (8 caracteres)').to be true
    end

    it 'false when cep has more than 8 characters' do
      buffet = Buffet.new cep: '123456789'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CEP não possui o tamanho esperado (8 caracteres)').to be true
    end

    it "false when cnpj isn't a number" do
      buffet = Buffet.new cnpj: 'qwertyuiopasdf'

      buffet.valid?

      expect(buffet.errors.full_messages.include? 'CNPJ não é um número').to be true
    end

    it "false when phone isn't a number" do
      buffet = Buffet.new cnpj: '1234567890'

      buffet.valid?

      expect(buffet.errors.full_messages.include? 'Telefone não é um número').to be true
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

      buffet = Buffet.new cnpj: '12345678000190'

      buffet.valid?

      expect(buffet.errors.full_messages.include? 'CNPJ já está em uso').to be true
    end

    it "false when buffet owner isn't unique" do
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

      buffet = Buffet.new buffet_owner: user

      buffet.valid?

      expect(buffet.errors.full_messages.include? 'Usuário já está em uso').to be true
    end
  end
end
