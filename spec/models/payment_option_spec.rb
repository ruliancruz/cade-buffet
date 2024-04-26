require 'rails_helper'

RSpec.describe PaymentOption, type: :model do
  describe '#long_installment_limit' do
    it 'returns described installment limit when it is greater than 1 ' do
      payment_option = PaymentOption.new installment_limit: 2

      expect(payment_option.long_installment_limit).to eq 'Parcela em até 2x'
    end

    it "returns À vista when installment limit isn't greater than 1" do
      payment_option = PaymentOption.new installment_limit: 1

      expect(payment_option.long_installment_limit).to eq 'À vista'
    end
  end

  describe '#valid?' do
    it "false when name is blank" do
      payment_option = PaymentOption.new name: ''

      payment_option.valid?

      expect(payment_option.errors.full_messages
        .include? 'Nome não pode ficar em branco').to be true
    end

    it "false when installment limit is blank" do
      payment_option = PaymentOption.new installment_limit: ''

      payment_option.valid?

      expect(payment_option.errors.full_messages
        .include? 'Limite de Parcelas não pode ficar em branco').to be true
    end

    it "false when buffet is missing" do
      payment_option = PaymentOption.new

      payment_option.valid?

      expect(payment_option.errors.full_messages
        .include? 'Buffet é obrigatório(a)').to be true
    end

    it "false when installment limit isn't be a number" do
      payment_option = PaymentOption.new installment_limit: 'twelven'

      payment_option.valid?

      expect(payment_option.errors.full_messages
        .include? 'Limite de Parcelas não é um número').to be true
    end

    it 'false when installment limit is lesser than 0' do
      payment_option = PaymentOption.new installment_limit: -1

      payment_option.valid?

      expect(payment_option.errors.full_messages
        .include? 'Limite de Parcelas deve ser maior ou igual a 1').to be true
    end

    it 'true when installment limit is greater or equal to 0' do
      payment_option = PaymentOption.new installment_limit: 0

      payment_option.valid?

      expect(payment_option.errors.full_messages
        .include? 'Limite de Parcelas não é um número').to be false
    end
  end
end
