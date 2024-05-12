require 'rails_helper'

RSpec.describe Order, type: :model do
  describe '#final_price' do
    it 'calculate and returns final price' do
      event_type = EventType.new minimum_attendees: 20

      base_price = BasePrice.new minimum: 10_000, additional_per_person: 250

      order = Order
        .new price_adjustment: -500,
             attendees: 40,
             status: :approved_by_buffet,
             event_type: event_type,
             base_price: base_price

      expect(order.final_price).to eq 14_500
    end

    it 'calculate and returns final price without influence of additional ' \
       'per person if the number of attendees is equal to event type ' \
       'minimum attendees' do
      event_type = EventType.new minimum_attendees: 20

      base_price = BasePrice.new minimum: 10_000, additional_per_person: 250

      order = Order
        .new price_adjustment: -500,
             attendees: 20,
             status: :approved_by_buffet,
             event_type: event_type,
             base_price: base_price

      expect(order.final_price).to eq 9_500
    end

    it 'calculate and returns final price without influence of additional ' \
       'per person if the number of attendees is lesser than event type ' \
       'minimum attendees' do
      event_type = EventType.new minimum_attendees: 20

      base_price = BasePrice.new minimum: 10_000, additional_per_person: 250

      order = Order
        .new price_adjustment: -500,
             attendees: 19,
             status: :approved_by_buffet,
             event_type: event_type,
             base_price: base_price

      expect(order.final_price).to eq 9_500
    end

    it 'calculate and returns status if the status is equal to waiting for ' \
       'evaluation' do
      order = Order.new status: :waiting_for_evaluation

      expect(order.final_price).to eq I18n.translate :waiting_for_evaluation
    end
  end

  describe '#expired?' do
    it 'false when expiration date is later than current date' do
      order = Order.new expiration_date: Date.current + 1.day

      expect(order.expired?).to be false
    end

    it 'true when expiration date is equal than current date' do
      order = Order.new expiration_date: Date.current

      expect(order.expired?).to be true
    end

    it 'false when expiration date is null' do
      order = Order.new expiration_date: nil

      expect(order.expired?).to be false
    end
  end

  describe '#generate_code' do
    it 'generate an alphanumeric code with 8 characters' do
      order = Order.new

      order.generate_code

      expect(order.code.match? /\A[a-zA-Z0-9]+\z/).to be true
      expect(order.code.length).to eq 8
    end
  end

  describe '#valid?' do
    it 'false when date is blank' do
      order = Order.new date: ''

      order.valid?

      expect(order.errors.full_messages
        .include? 'Data do Evento não pode ficar em branco').to be true
    end

    it 'false when attendees is blank' do
      order = Order.new attendees: ''

      order.valid?

      expect(order.errors.full_messages
        .include? 'Quantidade Estimada de Convidados não pode ficar em branco')
        .to be true
    end

    it 'false when details is blank' do
      order = Order.new details: ''

      order.valid?

      expect(order.errors.full_messages
        .include? 'Detalhes Adicionais não pode ficar em branco').to be true
    end

    it 'false when status is blank' do
      order = Order.new status: ''

      order.valid?

      expect(order.errors.full_messages
        .include? 'Status não pode ficar em branco').to be true
    end

    it 'false when client is blank' do
      order = Order.new

      order.valid?

      expect(order.errors.full_messages
        .include? 'Cliente não pode ficar em branco').to be true
    end

    it 'false when event type is blank' do
      order = Order.new

      order.valid?

      expect(order.errors.full_messages
        .include? 'Tipo de Evento não pode ficar em branco').to be true
    end

    it "false when attendees isn't a number" do
      order = Order.new attendees: 'forty'

      order.valid?

      expect(order.errors.full_messages
        .include? 'Quantidade Estimada de Convidados não é um número')
        .to be true
    end

    it "false when attendees is equal to 0" do
      order = Order.new attendees: 0

      order.valid?

      expect(order.errors.full_messages
        .include? 'Quantidade Estimada de Convidados deve ser maior que 0')
        .to be true
    end

    it "true when attendees is equal to 1" do
      order = Order.new attendees: 1

      order.valid?

      expect(order.errors.full_messages
        .include? 'Quantidade Estimada de Convidados deve ser maior que 0')
        .to be false
    end

    it "false when date is earlier current date" do
      order = Order.new date: Date.current - 1.day

      order.valid?

      expect(order.errors.full_messages
        .include? 'Data do Evento precisa ser atual ou futura').to be true
    end

    it "false when expiration date is earlier than current date" do
      order = Order
        .new date: Date.current + 1.week, expiration_date: Date.current - 1.day

      order.valid?

      expect(order.errors.full_messages
       .include? "Data de Validade do Preço precisa estar entre " \
       "#{I18n.localize Date.current} e #{I18n.localize order.date}")
       .to be true
    end

    it "true when expiration date is equal to current date" do
      order = Order
        .new date: Date.current + 1.week, expiration_date: Date.current

      order.valid?

      expect(order.errors.full_messages
        .include? "Data de Validade do Preço precisa estar entre " \
        "#{I18n.localize Date.current} e #{I18n.localize order.date}")
        .to be false
    end

    it "false when expiration date is later than date" do
      order = Order
        .new date: Date.current + 1.week,
             expiration_date: Date.current + 8.days

      order.valid?

      expect(order.errors.full_messages
        .include? "Data de Validade do Preço precisa estar entre " \
        "#{I18n.localize Date.current} e #{I18n.localize order.date}")
        .to be true
    end

    it "false when expiration date is equal than date" do
      order = Order
        .new date: Date.current + 1.week,
             expiration_date: Date.current + 1.week

      order.valid?

      expect(order.errors.full_messages
        .include? "Data de Validade do Preço precisa estar entre " \
        "#{I18n.localize Date.current} e #{I18n.localize order.date}")
        .to be false
    end

    it 'false when price adjustment description is present and price ' \
       'adjustment is blank' do
      order = Order.new price_adjustment_description: 'Descrição'

      order.valid?

      expect(order.errors.full_messages
        .include? 'Ajuste de Preço Ajuste de Preço não pode ficar em branco ' \
        'quando a Justificativa do Ajuste de Preço estiver preenchida')
        .to be true
    end
  end
end
