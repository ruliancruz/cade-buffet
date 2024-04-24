require 'rails_helper'

RSpec.describe EventType, type: :model do
  describe '#provides_alcohol_drinks_text' do
    it 'returns Sim if provides alcohol drinks is true' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: false,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type.provides_alcohol_drinks_text).to eq 'Sim'
    end

    it 'returns Não if provides alcohol drinks is false' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: false,
                                 provides_decoration: false,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type.provides_alcohol_drinks_text).to eq 'Não'
    end
  end

  describe '#provides_decoration_text' do
    it 'returns Sim if provides decoration text is true' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: false,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type.provides_decoration_text).to eq 'Sim'
    end

    it 'returns Não if provides decoration text is false' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: false,
                                 provides_decoration: false,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type.provides_decoration_text).to eq 'Não'
    end
  end

  describe '#provides_parking_service_text' do
    it 'returns Sim if provides parking service is true' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: false,
                                 provides_decoration: false,
                                 provides_parking_service: true,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type.provides_parking_service_text).to eq 'Sim'
    end

    it 'returns Não if provides parking service is false' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: false,
                                 provides_decoration: false,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type.provides_parking_service_text).to eq 'Não'
    end
  end

  describe '#serves_external_address_text' do
    it 'returns Sim if serves external address is true' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: false,
                                 provides_decoration: false,
                                 provides_parking_service: false,
                                 serves_external_address: true,
                                 buffet: buffet

      expect(event_type.serves_external_address_text).to eq 'Sim'
    end

    it 'returns Não if serves external address is false' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: false,
                                 provides_decoration: false,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type.serves_external_address_text).to eq 'Não'
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

      event_type = EventType.new name: '',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: '',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

    it 'false when minimum attendees is blank' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: '',
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

    it 'false when maximum attendees is blank' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: '',
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

    it 'false when duration is blank' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: '',
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

    it 'false when menu is blank' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: '',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

    it 'false when provides alcohol drinks is missing' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

    it 'false when provides decoration is missing' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

    it 'false when provides parking service is missing' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

    it 'false when serves external address is missing' do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

    it 'false when buffet is missing' do
      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false

      expect(event_type).not_to be_valid
    end

    it "false when minimum attendees isn't a number" do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 'twenty',
                                 maximum_attendees: 50,
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

    it "false when minimum attendees isn't a number" do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 'fifty',
                                 duration: 120,
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end

    it "false when duration isn't a number" do
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

      event_type = EventType.new name: 'Coquetel de Networking Empresarial',
                                 description: 'Um evento descontraído',
                                 minimum_attendees: 20,
                                 maximum_attendees: 50,
                                 duration: 'one hundred twenty',
                                 menu: 'Seleção de queijos, frutas e vinhos',
                                 provides_alcohol_drinks: true,
                                 provides_decoration: true,
                                 provides_parking_service: false,
                                 serves_external_address: false,
                                 buffet: buffet

      expect(event_type).not_to be_valid
    end
  end
end
