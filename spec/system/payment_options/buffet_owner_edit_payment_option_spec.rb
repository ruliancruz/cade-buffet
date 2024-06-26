require 'rails_helper'

describe 'Buffet owner edits a payment option' do
  it 'from the buffet page' do
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

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    login_as buffet_owner, scope: :buffet_owner
    visit buffet_path buffet
    click_on 'Cartão de Crédito'

    expect(current_path).to eq edit_payment_option_path payment_option

    within 'h1' do
      expect(page).to have_content 'Editar Meio de Pagamento'
    end

    within 'main form' do
      expect(page).to have_field 'Nome', with: 'Cartão de Crédito'
      expect(page).to have_field 'Limite de Parcelas', with: '12'

      expect(page).to have_button 'Atualizar Meio de Pagamento'
    end
  end

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

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    login_as buffet_owner, scope: :buffet_owner
    visit edit_payment_option_path payment_option

    within 'main form' do
      fill_in 'Nome', with: 'Cartão de Crédito'
      fill_in 'Limite de Parcelas', with: '12'

      click_on 'Atualizar Meio de Pagamento'
    end

    expect(current_path).to eq buffet_path buffet

    expect(page).to have_content 'Cartão de Crédito'
    expect(page).to have_content 'Parcela em até 12x'
  end

  it 'and see error messages when a field fails its validation' do
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

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    login_as buffet_owner, scope: :buffet_owner
    visit edit_payment_option_path payment_option

    within 'main form' do
      fill_in 'Nome', with: ''
      fill_in 'Limite de Parcelas', with: ''

      click_on 'Atualizar Meio de Pagamento'
    end

    expect(page).to have_content 'Preencha todos os campos corretamente ' \
                                 'para atualizar o meio de pagamento.'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Limite de Parcelas não pode ficar em branco'
    expect(page).to have_content 'Limite de Parcelas não é um número'
  end

  it 'returning to his own buffet page if he tries to access another one ' \
     'payment option edition page' do
    first_buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second_buffet_owner@example.com',
               password: 'second-password'

    first_buffet = Buffet
      .create! corporate_name: 'Sabores Deliciosos Ltda.',
               brand_name: 'Chef & Cia Buffet',
               cnpj: '34340299000145',
               phone: '9887654321',
               address: 'Avenida das Delícias, 456',
               district: 'Gourmet',
               city: 'Saborville',
               state: 'SP',
               cep: '87654321',
               buffet_owner: first_buffet_owner

    second_buffet = Buffet
      .create! corporate_name: 'Delícias Gastronômicas Ltda.',
               brand_name: 'Sabor & Arte Buffet',
               cnpj: '96577377000187',
               phone: '7531274464',
               address: 'Rua dos Sabores, 123',
               district: 'Centro',
               city: 'Culinária City',
               state: 'BA',
               cep: '12345678',
               buffet_owner: second_buffet_owner

    PaymentOption
      .create! name: 'Cartão de Crédito',
               installment_limit: 12,
               buffet: first_buffet

    second_payment_option = PaymentOption
      .create! name: 'Pix', installment_limit: 1, buffet: second_buffet

    login_as first_buffet_owner, scope: :buffet_owner
    visit edit_payment_option_path second_payment_option

    expect(current_path).to eq buffet_path first_buffet
    expect(page).to have_content 'Sabores Deliciosos Ltda.'
  end

  it "returning to buffet owner sign in page if he isn't signed in" do
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

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    visit edit_payment_option_path payment_option

    expect(current_path).to eq new_buffet_owner_session_path
  end

  it "returning to home page if he is a client" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    client = Client
      .create! name: 'João da Silva',
               cpf: '11480076015',
               email: 'client@example.com',
               password: 'client-password'

    buffet = Buffet
      .create! corporate_name: 'Delícias Gastronômicas Ltda.',
               brand_name: 'Sabor & Arte Buffet',
               cnpj: '96577377000187',
               phone: '7531274464',
               address: 'Rua dos Sabores, 123',
               district: 'Centro',
               city: 'Culinária City',
               state: 'BA',
               cep: '12345678',
               buffet_owner: buffet_owner

    payment_option = PaymentOption
      .create! name: 'Cartão de Crédito', installment_limit: 12, buffet: buffet

    login_as client, scope: :client
    visit edit_payment_option_path payment_option

    expect(current_path).to eq root_path
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet." do
    buffet_owner = BuffetOwner.create! email: 'buffet_owner@example.com', password: 'password'

    login_as buffet_owner, scope: :buffet_owner
    visit edit_payment_option_path 1

    expect(current_path).to eq new_buffet_path

    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end