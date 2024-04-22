require 'rails_helper'

describe 'Buffet owner register payment option' do
  it 'from buffet page' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                   brand_name: 'Sabor & Arte Buffet',
                   cnpj: '12345678000190',
                   phone: '7531274464',
                   address: 'Rua dos Sabores, 123',
                   district: 'Centro',
                   city: 'Culinária City',
                   state: 'BA',
                   cep: '12345678',
                   buffet_owner: user

    login_as user
    visit buffet_path 1
    click_on 'Adicionar Meio de Pagamento'

    within all("form")[1] do
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Limite de Parcelas'
    end
  end

  it 'with success' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                   brand_name: 'Sabor & Arte Buffet',
                   cnpj: '12345678000190',
                   phone: '7531274464',
                   address: 'Rua dos Sabores, 123',
                   district: 'Centro',
                   city: 'Culinária City',
                   state: 'BA',
                   cep: '12345678',
                   description: 'Oferecemos uma experiência gastronômica única.',
                   buffet_owner: user

    login_as user
    visit new_payment_option_path

    within all("form")[1] do
      fill_in 'Nome', with: 'Cartão de Crédito'
      fill_in 'Limite de Parcelas', with: '12'
      click_on 'Criar Meio de Pagamento'
    end

    expect(current_path).to eq buffet_path 1
    expect(page).to have_content 'Cartão de Crédito'
    expect(page).to have_content 'Parcela em até 12x'
    expect(PaymentOption.last.buffet.brand_name).to eq 'Sabor & Arte Buffet'
  end

  it 'and see error messages when a field fails its validation' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                   brand_name: 'Sabor & Arte Buffet',
                   cnpj: '12345678000190',
                   phone: '7531274464',
                   address: 'Rua dos Sabores, 123',
                   district: 'Centro',
                   city: 'Culinária City',
                   state: 'BA',
                   cep: '12345678',
                   description: 'Oferecemos uma experiência gastronômica única.',
                   buffet_owner: user

    login_as user
    visit new_payment_option_path
    click_on 'Criar Meio de Pagamento'

    expect(page).to have_content 'Preencha todos os campos corretamente ' \
                                 'para cadastrar o meio de pagamento.'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Limite de Parcelas não pode ficar em branco'
    expect(page).to have_content 'Limite de Parcelas não é um número'
  end

  it "returning to sign in page if he isn't signed in" do
    visit new_payment_option_path

    expect(current_path).to eq new_buffet_owner_session_path
  end
end