require 'rails_helper'

RSpec.describe BasePrice, type: :model do
  it 'calculate and returns default price' do
    event_type = EventType.new minimum_attendees: 20

    base_price =
      BasePrice.new minimum: 10_000,
                    additional_per_person: 250,
                    event_type: event_type

    expect(base_price.default_price(40)).to eq 15_000
  end

  describe '#valid?' do
    it 'false when description is blank' do
      base_price = BasePrice.new description: ''

      base_price.valid?

      expect(base_price.errors.full_messages
        .include? 'Descrição não pode ficar em branco').to be true
    end

    it 'false when minimum is blank' do
      base_price = BasePrice.new minimum: ''

      base_price.valid?

      expect(base_price.errors.full_messages
        .include? 'Valor Mínimo não pode ficar em branco').to be true
    end

    it 'false when additional per person is blank' do
      base_price = BasePrice.new additional_per_person: ''

      base_price.valid?

      expect(base_price.errors.full_messages
        .include? 'Adicional por Pessoa não pode ficar em branco').to be true
    end

    it 'false when event type is missing' do
      base_price = BasePrice.new

      base_price.valid?

      expect(base_price.errors.full_messages
        .include? 'Tipo de Evento é obrigatório(a)').to be true
    end

    it "false when minimum isn't a number" do
      base_price = BasePrice.new minimum: 'ten thousand'

      base_price.valid?

      expect(base_price.errors.full_messages
        .include? 'Valor Mínimo não é um número').to be true
    end

    it "false when additional per person isn't a number" do
      base_price = BasePrice.new additional_per_person: 'two hundred fifty'

      base_price.valid?

      expect(base_price.errors.full_messages
        .include? 'Adicional por Pessoa não é um número').to be true
    end

    it "false when minimum isn't a positive number" do
      base_price = BasePrice.new minimum: -1

      base_price.valid?

      expect(base_price.errors.full_messages
        .include? 'Valor Mínimo deve ser maior ou igual a 0').to be true
    end

    it 'true when minimum is a positive number' do
      base_price = BasePrice.new minimum: 0

      base_price.valid?

      expect(base_price.errors.full_messages
        .include? 'Valor Mínimo deve ser maior ou igual a 0').to be false
    end

    it "false when additional per person isn't a positive number" do
      base_price = BasePrice.new additional_per_person: -1

      base_price.valid?

      expect(base_price.errors.full_messages
        .include? 'Adicional por Pessoa deve ser maior ou igual a 0')
        .to be true
    end

    it 'true when additional per person is a positive number' do
      base_price = BasePrice.new additional_per_person: 0

      base_price.valid?

      expect(base_price.errors.full_messages
        .include? 'Adicional por Pessoa deve ser maior ou igual a 0')
        .to be false
    end
  end
end
