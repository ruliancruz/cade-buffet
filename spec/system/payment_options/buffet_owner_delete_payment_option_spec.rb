require 'rails_helper'

describe 'Buffet owner deletes a payment option' do
  it 'with success' do
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
               buffet_owner: buffet_owner

    PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    login_as buffet_owner, scope: :buffet_owner
    visit buffet_path buffet
    click_on 'Remover'

    expect(current_path).to eq buffet_path buffet

    expect(page).to have_content 'Meio de pagamento removido com sucesso!'

    expect(page).not_to have_content 'Cartão de Crédito'
    expect(page).not_to have_content 'Parcela em até 12x'
  end
end