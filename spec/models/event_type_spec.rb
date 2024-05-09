require 'rails_helper'

RSpec.describe EventType, type: :model do
  describe '#provides_alcohol_drinks_text' do
    it 'returns Sim if provides alcohol drinks is true' do
      event_type = EventType.new provides_alcohol_drinks: true

      expect(event_type.provides_alcohol_drinks_text).to eq 'Sim'
    end

    it 'returns Não if provides alcohol drinks is false' do
      event_type = EventType.new provides_alcohol_drinks: false

      expect(event_type.provides_alcohol_drinks_text).to eq 'Não'
    end
  end

  describe '#provides_decoration_text' do
    it 'returns Sim if provides decoration text is true' do
      event_type = EventType.new provides_decoration: true

      expect(event_type.provides_decoration_text).to eq 'Sim'
    end

    it 'returns Não if provides decoration text is false' do
      event_type = EventType.new provides_decoration: false

      expect(event_type.provides_decoration_text).to eq 'Não'
    end
  end

  describe '#provides_parking_service_text' do
    it 'returns Sim if provides parking service is true' do
      event_type = EventType.new provides_parking_service: true

      expect(event_type.provides_parking_service_text).to eq 'Sim'
    end

    it 'returns Não if provides parking service is false' do
      event_type = EventType.new provides_parking_service: false

      expect(event_type.provides_parking_service_text).to eq 'Não'
    end
  end

  describe '#serves_external_address_text' do
    it 'returns Sim if serves external address is true' do
      event_type = EventType.new serves_external_address: true

      expect(event_type.serves_external_address_text).to eq 'Sim'
    end

    it 'returns Não if serves external address is false' do
      event_type = EventType.new serves_external_address: false

      expect(event_type.serves_external_address_text).to eq 'Não'
    end
  end

  describe '#valid?' do
    it 'false when name is blank' do
      event_type = EventType.new name: ''

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Nome não pode ficar em branco').to be true
    end

    it 'false when description is blank' do
      event_type = EventType.new description: ''

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Descrição não pode ficar em branco').to be true
    end

    it 'false when minimum attendees is blank' do
      event_type = EventType.new minimum_attendees: ''

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Mínimo de Pessoas não pode ficar em branco').to be true
    end

    it 'false when maximum attendees is blank' do
      event_type = EventType.new maximum_attendees: ''

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Máximo de Pessoas não pode ficar em branco').to be true
    end

    it 'false when duration is blank' do
      event_type = EventType.new duration: ''

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Duração não pode ficar em branco').to be true
    end

    it 'false when menu is blank' do
      event_type = EventType.new menu: ''

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Cardápio não pode ficar em branco').to be true
    end

    it 'false when provides alcohol drinks is missing' do
      event_type = EventType.new

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Fornece Bebidas Alcoólicas não pode ficar em branco')
        .to be true
    end

    it 'false when provides decoration is missing' do
      event_type = EventType.new

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Fornece Decoração não pode ficar em branco').to be true
    end

    it 'false when provides parking service is missing' do
      event_type = EventType.new

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Fornece Serviço de Estacionamento não pode ficar em branco')
        .to be true
    end

    it 'false when serves external address is missing' do
      event_type = EventType.new

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Atende a Endereço Indicado por Cliente não pode ficar em ' \
                  'branco').to be true
    end

    it 'false when buffet is missing' do
      event_type = EventType.new

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Buffet é obrigatório(a)').to be true
    end

    it "false when minimum attendees isn't a number" do
      event_type = EventType.new minimum_attendees: 'twenty'

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Mínimo de Pessoas não é um número').to be true
    end

    it "false when maximum attendees isn't a number" do
      event_type = EventType.new maximum_attendees: 'fifty'

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Máximo de Pessoas não é um número').to be true
    end

    it "false when duration isn't a number" do
      event_type = EventType.new duration: 'twenty'

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Duração não é um número').to be true
    end

    it "false when minimum attendees isn't a positive number" do
      event_type = EventType.new minimum_attendees: -1

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Mínimo de Pessoas deve ser maior ou igual a 0').to be true
    end

    it "true when minimum attendees is a positive number" do
      event_type = EventType.new minimum_attendees: 0

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Mínimo de Pessoas deve ser maior ou igual a 0').to be false
    end

    it "false when maximum attendees isn't a positive number" do
      event_type = EventType.new maximum_attendees: -1

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Máximo de Pessoas deve ser maior ou igual a 0').to be true
    end

    it "false when maximum attendees is a positive number" do
      event_type = EventType.new maximum_attendees: 0

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Máximo de Pessoas deve ser maior ou igual a 0').to be false
    end

    it "false when duration isn't a positive number" do
      event_type = EventType.new duration: -1

      event_type.valid?

      expect(event_type.errors.full_messages
        .include? 'Duração deve ser maior ou igual a 0').to be true
    end
  end
end
