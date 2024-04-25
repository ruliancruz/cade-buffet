require 'rails_helper'

RSpec.describe BasePrice, type: :model do
  describe '#valid?' do
    it 'false when description is blank' do
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

      event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                     description: 'Um evento descontraído.',
                                     minimum_attendees: 20,
                                     maximum_attendees: 50,
                                     duration: 120,
                                     menu: 'Seleção de queijos, frutas e vinhos',
                                     provides_alcohol_drinks: true,
                                     provides_decoration: true,
                                     provides_parking_service: false,
                                     serves_external_address: false,
                                     buffet: buffet

      base_price = BasePrice.new description: '',
                                 minimum: 10_000,
                                 additional_per_person: 250,
                                 event_type: event_type

      expect(base_price).not_to be_valid
    end

    it 'false when minimum is blank' do
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

      event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                     description: 'Um evento descontraído.',
                                     minimum_attendees: 20,
                                     maximum_attendees: 50,
                                     duration: 120,
                                     menu: 'Seleção de queijos, frutas e vinhos',
                                     provides_alcohol_drinks: true,
                                     provides_decoration: true,
                                     provides_parking_service: false,
                                     serves_external_address: false,
                                     buffet: buffet

      base_price = BasePrice.new description: 'Meio de Semana',
                                 minimum: '',
                                 additional_per_person: 250,
                                 event_type: event_type

      expect(base_price).not_to be_valid
    end

    it 'false when additional per person is blank' do
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

      event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                     description: 'Um evento descontraído.',
                                     minimum_attendees: 20,
                                     maximum_attendees: 50,
                                     duration: 120,
                                     menu: 'Seleção de queijos, frutas e vinhos',
                                     provides_alcohol_drinks: true,
                                     provides_decoration: true,
                                     provides_parking_service: false,
                                     serves_external_address: false,
                                     buffet: buffet

      base_price = BasePrice.new description: 'Meio de Semana',
                                 minimum: 10_000,
                                 additional_per_person: '',
                                 event_type: event_type

      expect(base_price).not_to be_valid
    end

    it 'false when event type is missing' do
      base_price = BasePrice.new description: 'Meio de Semana',
                                 minimum: 10_000,
                                 additional_per_person: 250

      expect(base_price).not_to be_valid
    end

    it "false when minimum isn't a number" do
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

      event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                     description: 'Um evento descontraído.',
                                     minimum_attendees: 20,
                                     maximum_attendees: 50,
                                     duration: 120,
                                     menu: 'Seleção de queijos, frutas e vinhos',
                                     provides_alcohol_drinks: true,
                                     provides_decoration: true,
                                     provides_parking_service: false,
                                     serves_external_address: false,
                                     buffet: buffet

      base_price = BasePrice.new description: 'Meio de Semana',
                                 minimum: 'ten thousand',
                                 additional_per_person: 250,
                                 event_type: event_type

      expect(base_price).not_to be_valid
    end

    it "false when additional per person isn't a number" do
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

      event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                     description: 'Um evento descontraído.',
                                     minimum_attendees: 20,
                                     maximum_attendees: 50,
                                     duration: 120,
                                     menu: 'Seleção de queijos, frutas e vinhos',
                                     provides_alcohol_drinks: true,
                                     provides_decoration: true,
                                     provides_parking_service: false,
                                     serves_external_address: false,
                                     buffet: buffet

      base_price = BasePrice.new description: 'Meio de Semana',
                                 minimum: 10_000,
                                 additional_per_person: 'two hundred fifty',
                                 event_type: event_type

      expect(base_price).not_to be_valid
    end

    it "false when minimum isn't a positive number" do
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

      event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                     description: 'Um evento descontraído.',
                                     minimum_attendees: 20,
                                     maximum_attendees: 50,
                                     duration: 120,
                                     menu: 'Seleção de queijos, frutas e vinhos',
                                     provides_alcohol_drinks: true,
                                     provides_decoration: true,
                                     provides_parking_service: false,
                                     serves_external_address: false,
                                     buffet: buffet

      base_price = BasePrice.new description: 'Meio de Semana',
                                 minimum: -1,
                                 additional_per_person: 250,
                                 event_type: event_type

      expect(base_price).not_to be_valid
    end

    it "false when additional per person isn't a positive number" do
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

      event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                     description: 'Um evento descontraído.',
                                     minimum_attendees: 20,
                                     maximum_attendees: 50,
                                     duration: 120,
                                     menu: 'Seleção de queijos, frutas e vinhos',
                                     provides_alcohol_drinks: true,
                                     provides_decoration: true,
                                     provides_parking_service: false,
                                     serves_external_address: false,
                                     buffet: buffet

      base_price = BasePrice.new description: 'Meio de Semana',
                                 minimum: 10_000,
                                 additional_per_person: -1,
                                 event_type: event_type

      expect(base_price).not_to be_valid
    end
  end
end
