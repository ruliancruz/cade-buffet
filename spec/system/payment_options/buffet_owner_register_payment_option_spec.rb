require 'rails_helper'

describe 'Buffet owner register payment option' do
  it 'from buffet page' do
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

    login_as buffet_owner, scope: :buffet_owner
    visit buffet_path buffet
    click_on 'Adicionar Meio de Pagamento'

    expect(page).to have_content 'Adicionar Meio de Pagamento'

    within 'main form' do
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Limite de Parcelas'
    end
  end

  it 'with success' do
    first_buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second_buffet_owner@example.com',
               password: 'second-password'

    first_buffet = Buffet
      .create! corporate_name: 'Delícias Gastronômicas Ltda.',
               brand_name: 'Sabor & Arte Buffet',
               cnpj: '34340299000145',
               phone: '7531274464',
               address: 'Rua dos Sabores, 123',
               district: 'Centro',
               city: 'Culinária City',
               state: 'BA',
               cep: '12345678',
               buffet_owner: first_buffet_owner

    Buffet
      .create! corporate_name: 'Sabores Deliciosos Ltda.',
               brand_name: 'Chef & Cia Buffet',
               cnpj: '96577377000187',
               phone: '9887654321',
               address: 'Avenida das Delícias, 456',
               district: 'Bairro Gourmet',
               city: 'Saborville',
               state: 'SP',
               cep: '87654321',
               buffet_owner: second_buffet_owner

    login_as first_buffet_owner, scope: :buffet_owner
    visit new_payment_option_path

    within 'main form' do
      fill_in 'Nome', with: 'Cartão de Crédito'
      fill_in 'Limite de Parcelas', with: '12'

      click_on 'Criar Meio de Pagamento'
    end

    expect(current_path).to eq buffet_path first_buffet

    expect(page).to have_content 'Cartão de Crédito'
    expect(page).to have_content 'Parcela em até 12x'
    expect(PaymentOption.last.buffet.brand_name).to eq 'Sabor & Arte Buffet'
  end

  it 'and see error messages when a field fails its validation' do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

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
               description: 'Oferecemos uma experiência gastronômica única.',
               buffet_owner: buffet_owner

    login_as buffet_owner, scope: :buffet_owner
    visit new_payment_option_path
    click_on 'Criar Meio de Pagamento'

    expect(page).to have_content 'Preencha todos os campos corretamente ' \
                                 'para cadastrar o meio de pagamento.'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Limite de Parcelas não pode ficar em branco'
    expect(page).to have_content 'Limite de Parcelas não é um número'
  end

  it "returning to buffet owner sign in page if he isn't signed in" do
    visit new_payment_option_path

    expect(current_path).to eq new_buffet_owner_session_path
  end

  it "returning to home page if he is a client" do
    client = Client
      .create! name: 'João da Silva',
               cpf: '46986327064',
               email: 'client@example.com',
               password: 'password'

    login_as client, scope: :client
    visit new_payment_option_path

    expect(current_path).to eq root_path
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet." do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    login_as buffet_owner, scope: :buffet_owner
    visit new_payment_option_path

    expect(current_path).to eq new_buffet_path

    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end