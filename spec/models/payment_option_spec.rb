require 'rails_helper'

RSpec.describe PaymentOption, type: :model do
  describe '#long_installment_limit' do
    it 'returns described installment limit' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                              brand_name: 'Sabor & Arte Buffet',
                              cnpj: '12345678000190',
                              phone: '7531274464',
                              address: 'Rua dos Sabores, 123',
                              district: 'Centro',
                              city: 'Culinária City',
                              state: 'BA',
                              cep: '12345678',
                              buffet_owner: user

      payment_option = PaymentOption.new name: 'Cartão de Crédito',
                                         installment_limit: 4,
                                         buffet: buffet

      expect(payment_option.long_installment_limit).to eq "Parcela em até 4x"
    end

    it 'returns in cash when installment limit is lesser than 2' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                              brand_name: 'Sabor & Arte Buffet',
                              cnpj: '12345678000190',
                              phone: '7531274464',
                              address: 'Rua dos Sabores, 123',
                              district: 'Centro',
                              city: 'Culinária City',
                              state: 'BA',
                              cep: '12345678',
                              buffet_owner: user

      payment_option = PaymentOption.new name: 'Cartão de Crédito',
                                         installment_limit: 1,
                                         buffet: buffet

      expect(payment_option.long_installment_limit).to eq "À vista"
    end
  end

  describe '#valid?' do
    it 'false when name is blank' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                              brand_name: 'Sabor & Arte Buffet',
                              cnpj: '12345678000190',
                              phone: '7531274464',
                              address: 'Rua dos Sabores, 123',
                              district: 'Centro',
                              city: 'Culinária City',
                              state: 'BA',
                              cep: '12345678',
                              buffet_owner: user

      payment_option = PaymentOption.new name: '',
                                         installment_limit: 12,
                                         buffet: buffet

      expect(payment_option).not_to be_valid
    end

    it 'false when buffet is missing' do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                              brand_name: 'Sabor & Arte Buffet',
                              cnpj: '12345678000190',
                              phone: '7531274464',
                              address: 'Rua dos Sabores, 123',
                              district: 'Centro',
                              city: 'Culinária City',
                              state: 'BA',
                              cep: '12345678',
                              buffet_owner: user

      payment_option = PaymentOption.new name: 'Cartão de Crédito',
                                         installment_limit: 12

      expect(payment_option).not_to be_valid
    end

    it "false when installment_limit isn't a number" do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                              brand_name: 'Sabor & Arte Buffet',
                              cnpj: '12345678000190',
                              phone: '7531274464',
                              address: 'Rua dos Sabores, 123',
                              district: 'Centro',
                              city: 'Culinária City',
                              state: 'BA',
                              cep: '12345678',
                              buffet_owner: user

      payment_option = PaymentOption.new name: 'Cartão de Crédito',
                                         installment_limit: 'twelven',
                                         buffet: buffet

      expect(payment_option).not_to be_valid
    end

    it "false when installment_limit is lesser than 0" do
      user = BuffetOwner.create! email: 'user@example.com', password: 'password'

      buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                              brand_name: 'Sabor & Arte Buffet',
                              cnpj: '12345678000190',
                              phone: '7531274464',
                              address: 'Rua dos Sabores, 123',
                              district: 'Centro',
                              city: 'Culinária City',
                              state: 'BA',
                              cep: '12345678',
                              buffet_owner: user

      payment_option = PaymentOption.new name: 'Cartão de Crédito',
                                         installment_limit: '0',
                                         buffet: buffet

      expect(payment_option).not_to be_valid
    end
  end
end
