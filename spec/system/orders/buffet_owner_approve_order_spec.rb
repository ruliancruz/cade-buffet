require 'rails_helper'

describe 'buffet owner approve order' do
  it 'from the order page' do
    buffet_owner = BuffetOwner.create! email: 'user@example.com', password: 'password'

    client = Client.create! name: 'Clientine',
                            cpf: '11480076015',
                            email: 'client@example.com',
                            password: 'client-password'

    buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                            brand_name: 'Sabor & Arte Buffet',
                            cnpj: '34340299000145',
                            phone: '7531274464',
                            address: 'Rua dos Sabores, 123',
                            district: 'Centro',
                            city: 'Culinária City',
                            state: 'BA',
                            cep: '12345678',
                            buffet_owner: buffet_owner

    event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                   description: 'Um evento descontraído.',
                                   minimum_attendees: 20,
                                   maximum_attendees: 50,
                                   duration: 120,
                                   menu: 'Seleção de queijos, frutas e vinhos',
                                   provides_alcohol_drinks: true,
                                   provides_decoration: false,
                                   provides_parking_service: false,
                                   serves_external_address: true,
                                   buffet: buffet

    payment_option = PaymentOption.create! name: 'Cartão de Crédito',
                                           installment_limit: 12,
                                           buffet: buffet

    BasePrice.create! description: 'Meio de Semana',
                      minimum: 10_000,
                      additional_per_person: 250,
                      extra_hour_value: 1_000,
                      event_type: event_type

    BasePrice.create! description: 'Final de Semana',
                      minimum: 14_000,
                      additional_per_person: 300,
                      extra_hour_value: 1_500,
                      event_type: event_type

    order = Order.new date: I18n.localize(Date.current + 2.week),
                      attendees: 40,
                      details: 'Quero que inclua queijo suíço e vinho tinto.',
                      address: buffet.full_address,
                      status: :waiting_for_evaluation,
                      payment_option: payment_option,
                      event_type: event_type,
                      client: client

    order.generate_code
    order.save!

    login_as buffet_owner, scope: :buffet_owner
    visit order_path order
    click_on 'Aprovar Pedido'

    expect(current_path).to eq edit_order_path order
    expect(page).to have_content order.code

    within 'main form' do
      expect(page).to have_content 'Meio de Semana'
      expect(page).to have_content 'R$15.000,00'
      expect(page).to have_content 'Final de Semana'
      expect(page).to have_content 'R$20.000,00'
      expect(page).to have_select 'Preço-base'
      expect(page).to have_field 'Ajuste de Preço'
      expect(page).to have_content 'insira um número negativo para conceder desconto'
      expect(page).to have_field 'Justificativa do Ajuste de Preço'
      expect(page).to have_field 'Data de Validade do Preço',
        with: I18n.localize(Date.current + 2.week)

      expect(page).to have_select 'Meio de Pagamento', with_selected: 'Cartão de Crédito'
      expect(page).to have_button 'Aprovar Pedido'
    end
  end
end