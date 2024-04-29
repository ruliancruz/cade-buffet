require 'rails_helper'

RSpec.describe Client, type: :model do
  describe '#valid?' do
    it 'false when name is blank' do
      client = Client.new name: ''

      client.valid?

      expect(client.errors.full_messages
        .include? 'Nome não pode ficar em branco').to be true
    end

    it 'false when cpf is blank' do
      client = Client.new cpf: ''

      client.valid?

      expect(client.errors.full_messages
        .include? 'CPF não pode ficar em branco').to be true
    end

    it "false when cpf isn't a number" do
      client = Client.new cpf: 'qwertyuiopa'

      client.valid?

      expect(client.errors.full_messages
        .include? 'CPF não é um número').to be true
    end

    it "false when cpf have less than 11 digits" do
      client = Client.new cpf: '1234567890'

      client.valid?

      expect(client.errors.full_messages
        .include? 'CPF não possui o tamanho esperado (11 caracteres)').to be true
    end

    it "false when cpf have more than 11 digits" do
      client = Client.new cpf: '123456789012'

      client.valid?

      expect(client.errors.full_messages
        .include? 'CPF não possui o tamanho esperado (11 caracteres)').to be true
    end

    it "false when cpf isn't unique" do
      Client.create! name: 'User',
                     cpf: '11480076015',
                     email: 'client@example.com',
                     password: 'password'

      client = Client.new cpf: '11480076015'

      client.valid?

      expect(client.errors.full_messages.include? 'CPF já está em uso').to be true
    end
  end
end
