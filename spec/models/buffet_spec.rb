require 'rails_helper'

RSpec.describe Buffet, type: :model do
  describe '#availability_query' do
    it 'returns true and preview prices when buffet is available' do
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

      event_type = EventType
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
                 buffet: buffet

      BasePrice
        .create! description: 'Meio de Semana',
                 minimum: 10_000,
                 additional_per_person: 250,
                 extra_hour_value: 1_000,
                 event_type: event_type

      BasePrice
        .create! description: 'Final de Semana',
                 minimum: 14_000,
                 additional_per_person: 300,
                 extra_hour_value: 1_500,
                 event_type: event_type

      result = buffet.availability_query(event_type, Date.current, 40)

      expect(result[:available]).to eq true
      expect(result[:preview_prices][0][:description]).to eq 'Meio de Semana'
      expect(result[:preview_prices][0][:value]).to eq 15_000
      expect(result[:preview_prices][1][:description]).to eq 'Final de Semana'
      expect(result[:preview_prices][1][:value]).to eq 20_000
    end

    it "returns true and a empty preview prices array if there isn't any " \
       "base price in this buffet" do

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

      event_type = EventType
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
                 buffet: buffet

      result = buffet.availability_query(event_type, Date.current, 40)

      expect(result[:available]).to eq true
      expect(result[:preview_prices]).to eq []
    end

    it "returns false when buffet isn't available" do
      buffet_owner = BuffetOwner
        .create! email: 'buffet_owner@example.com', password: 'password'

      client = Client
        .create! name: 'Client',
                 cpf: '11480076015',
                 email: 'client@example.com',
                 password: 'client-password'

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

      event_type = EventType
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
                 buffet: buffet

      payment_option = PaymentOption
        .create! name: 'Cartão de Crédito',
                 installment_limit: 12,
                 buffet: buffet

      base_price = BasePrice
        .create! description: 'Meio de Semana',
                 minimum: 10_000,
                 additional_per_person: 250,
                 extra_hour_value: 1_000,
                 event_type: event_type

      Order
        .create! date: I18n.localize(Date.current + 1.week),
                 attendees: 40,
                 details: 'Quero que inclua queijo suíço e vinho tinto.',
                 address: buffet.full_address,
                 expiration_date: I18n.localize(Date.current + 2.days),
                 status: :approved_by_buffet,
                 base_price: base_price,
                 payment_option: payment_option,
                 event_type: event_type,
                 client: client

      result = buffet.availability_query(event_type, Date.current + 1.week, 40)

      expect(result[:available]).to eq false
      expect(result[:preview_prices]).to eq nil
    end
  end

  describe '#available_at_date?' do
    it "true when there isn't any approved by buffet or confirmed order on " \
       "this buffet scheduled for the informed date" do

      buffet_owner = BuffetOwner
        .create! email: 'buffet_owner@example.com', password: 'password'

      client = Client
       .create! name: 'Client',
                 cpf: '11480076015',
                 email: 'client@example.com',
                 password: 'client-password'

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

      first_event_type = EventType
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
                 buffet: buffet

      second_event_type = EventType
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
                 buffet: buffet

      first_base_price = BasePrice
        .create! description: 'Meio de Semana',
                 minimum: 10_000,
                 additional_per_person: 250,
                 extra_hour_value: 1_000,
                 event_type: first_event_type

      second_base_price = BasePrice
        .create! description: 'Final de Semana',
                 minimum: 14_000,
                 additional_per_person: 300,
                 extra_hour_value: 1_500,
                 event_type: second_event_type

      payment_option = PaymentOption
        .create! name: 'Cartão de Crédito',
                 installment_limit: 12,
                 buffet: buffet

      Order
        .create! date: I18n.localize(Date.current + 6.days),
                 attendees: 40,
                 details: 'Quero que inclua queijo suíço e vinho tinto.',
                 address: buffet.full_address,
                 expiration_date: I18n.localize(Date.current + 2.day),
                 status: :approved_by_buffet,
                 base_price: first_base_price,
                 payment_option: payment_option,
                 event_type: first_event_type,
                 client: client

      Order
        .create! date: I18n.localize(Date.current + 8.days),
                 attendees: 30,
                 details: 'Quero que inclua coxinhas e pasteis.',
                 address: buffet.full_address,
                 expiration_date: I18n.localize(Date.current + 4.day),
                 status: :confirmed,
                 base_price: second_base_price,
                 payment_option: payment_option,
                 event_type: second_event_type,
                 client: client

      Order
        .create! date: I18n.localize(Date.current + 1.week),
             attendees: 28,
             details: 'Quero que inclua só coxinhas.',
             address: buffet.full_address,
             status: :waiting_for_evaluation,
             payment_option: payment_option,
             event_type: first_event_type,
             client: client

      Order
        .create! date: I18n.localize(Date.current + 1.week),
                 attendees: 28,
                 details: 'Quero que inclua só coxinhas.',
                 address: buffet.full_address,
                 status: :canceled,
                 payment_option: payment_option,
                 event_type: first_event_type,
                 client: client

      expect(buffet.available_at_date? Date.current + 1.week).to be true
    end

    it "false when there is any approved by buffet order on this buffet " \
       "scheduled for the informed date" do

      buffet_owner = BuffetOwner
        .create! email: 'buffet_owner@example.com', password: 'password'

      client = Client
        .create! name: 'Client',
                 cpf: '11480076015',
                 email: 'client@example.com',
                 password: 'client-password'

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

      event_type = EventType
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
                 buffet: buffet

      base_price = BasePrice
        .create! description: 'Meio de Semana',
                 minimum: 10_000,
                 additional_per_person: 250,
                 extra_hour_value: 1_000,
                 event_type: event_type

      payment_option = PaymentOption
        .create! name: 'Cartão de Crédito',
                 installment_limit: 12,
                 buffet: buffet

      Order
        .create! date: I18n.localize(Date.current + 1.week),
                 attendees: 40,
                 details: 'Quero que inclua queijo suíço e vinho tinto.',
                 address: buffet.full_address,
                 expiration_date: I18n.localize(Date.current + 2.day),
                 status: :approved_by_buffet,
                 base_price: base_price,
                 payment_option: payment_option,
                 event_type: event_type,
                 client: client

      expect(buffet.available_at_date? Date.current + 1.week).to be false
    end

    it "false when there is any confirmed order on this buffet scheduled " \
       "for the informed date" do

      buffet_owner = BuffetOwner
        .create! email: 'buffet_owner@example.com', password: 'password'

      client = Client
        .create! name: 'Client',
                 cpf: '11480076015',
                 email: 'client@example.com',
                 password: 'client-password'

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

      event_type = EventType
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
                 buffet: buffet

      base_price = BasePrice
        .create! description: 'Meio de Semana',
                 minimum: 10_000,
                 additional_per_person: 250,
                 extra_hour_value: 1_000,
                 event_type: event_type

      payment_option = PaymentOption
        .create! name: 'Cartão de Crédito',
                 installment_limit: 12,
                 buffet: buffet

      Order
        .create! date: I18n.localize(Date.current + 1.week),
                 attendees: 40,
                 details: 'Quero que inclua queijo suíço e vinho tinto.',
                 address: buffet.full_address,
                 expiration_date: I18n.localize(Date.current + 2.day),
                 status: :confirmed,
                 base_price: base_price,
                 payment_option: payment_option,
                 event_type: event_type,
                 client: client

      expect(buffet.available_at_date? Date.current + 1.week).to be false
    end
  end

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
      buffet = Buffet.new cnpj: '34340299000145'

      expect(buffet.formatted_cnpj).to eq '34.340.299/0001-45'
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
      buffet = Buffet.new cnpj: '343402990001456'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CNPJ não possui o tamanho esperado (14 caracteres)')
        .to be true
    end

    it 'false when cnpj have more than 14 characters' do
      buffet = Buffet.new cnpj: '343402990001456'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CNPJ não possui o tamanho esperado (14 caracteres)')
        .to be true
    end

    it 'false when phone has less than 10 characters' do
      buffet = Buffet.new phone: '123456789'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Telefone é muito curto (mínimo: 10 caracteres)')
        .to be true
    end

    it 'false when phone has more than 11 characters' do
      buffet = Buffet.new phone: '123456789012'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Telefone é muito longo (máximo: 11 caracteres)')
        .to be true
    end

    it 'false when state has less than 2 characters' do
      buffet = Buffet.new state: 'B'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Estado não possui o tamanho esperado (2 caracteres)')
        .to be true
    end

    it 'false when state has more than 2 characters' do
      buffet = Buffet.new state: 'BAA'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Estado não possui o tamanho esperado (2 caracteres)')
        .to be true
    end

    it 'false when cep has less than 8 characters' do
      buffet = Buffet.new cep: '1234567'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CEP não possui o tamanho esperado (8 caracteres)')
        .to be true
    end

    it 'false when cep has more than 8 characters' do
      buffet = Buffet.new cep: '123456789'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CEP não possui o tamanho esperado (8 caracteres)')
        .to be true
    end

    it "false when cnpj isn't a number" do
      buffet = Buffet.new cnpj: 'qwertyuiopasdf'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CNPJ não é um número').to be true
    end

    it "false when phone isn't a number" do
      buffet = Buffet.new phone: 'qwertyuiop'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Telefone não é um número').to be true
    end

    it "false when cnpj isn't unique" do
      buffet_owner = BuffetOwner
        .create! email: 'user@example.com', password: 'password'

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
                 buffet_owner: buffet_owner

      buffet = Buffet.new cnpj: '34340299000145'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CNPJ já está em uso').to be true
    end

    it "false when buffet owner isn't unique" do
      buffet_owner = BuffetOwner
        .create! email: 'user@example.com', password: 'password'

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
                 buffet_owner: buffet_owner

      buffet = Buffet.new buffet_owner: buffet_owner

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'Usuário já está em uso').to be true
    end

    it "false when cnpj isn't valid" do
      buffet = Buffet.new cnpj: '34340299000144'

      buffet.valid?

      expect(buffet.errors.full_messages
        .include? 'CNPJ precisa ser válido').to be true
    end
  end
end
