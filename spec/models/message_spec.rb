require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#valid?' do
    it 'false when text is blank' do
      message = Message.new text: ''

      message.valid?

      expect(message.errors.full_messages
        .include? 'Deixe Sua Mensagem não pode ficar em branco').to be true
    end
  end
end
