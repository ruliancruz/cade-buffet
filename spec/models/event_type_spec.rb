require 'rails_helper'

RSpec.describe EventType, type: :model do
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
