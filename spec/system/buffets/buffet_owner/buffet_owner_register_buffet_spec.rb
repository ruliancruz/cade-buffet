require 'rails_helper'

describe 'Buffet owner register buffet' do
  it 'after creating his account' do
    visit new_buffet_owner_registration_path

    within 'main form' do
      fill_in 'E-mail', with: 'buffet_owner@example.com'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      click_on 'Criar Nova Conta'
    end

    within 'main form' do
      expect(page).to have_field 'Razão Social'
      expect(page).to have_field 'Nome Fantasia'
      expect(page).to have_field 'CNPJ'
      expect(page).to have_field 'Telefone'
      expect(page).to have_field 'Endereço'
      expect(page).to have_field 'Bairro'
      expect(page).to have_field 'Cidade'
      expect(page).to have_field 'Estado'
      expect(page).to have_field 'CEP'
      expect(page).to have_field 'Descrição'
    end
  end

  it 'with success' do
    first_buffet_owner = BuffetOwner
      .create! email: 'first_buffet_owner@example.com',
               password: 'first-password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second_buffet_owner@example.com',
               password: 'second-password'

    login_as second_buffet_owner, scope: :buffet_owner
    visit new_buffet_path

    within 'main form' do
      fill_in 'Razão Social', with: 'Delícias Gastronômicas Ltda.'
      fill_in 'Nome Fantasia', with: 'Sabor & Arte Buffet'
      fill_in 'CNPJ', with: '34340299000145'
      fill_in 'Telefone', with: '7531274464'
      fill_in 'Endereço', with: 'Rua dos Sabores, 123'
      fill_in 'Bairro', with: 'Centro'
      fill_in 'Cidade', with: 'Culinária City'
      fill_in 'Estado', with: 'BA'
      fill_in 'CEP', with: '12345678'

      fill_in 'Descrição',
        with: 'Oferecemos uma experiência gastronômica única.'

      click_on 'Criar Buffet'
    end

    expect(current_path).to eq buffet_path first_buffet_owner

    expect(page).to have_content 'Delícias Gastronômicas Ltda.'
    expect(page).to have_content 'Sabor & Arte Buffet'
    expect(page).to have_content '34.340.299/0001-45'
    expect(page).to have_content '(75) 3127-4464'

    expect(page).to have_content 'Rua dos Sabores, 123 - Centro, ' \
                                 'Culinária City - BA, 12345-678'

    expect(page)
      .to have_content 'Oferecemos uma experiência gastronômica única.'

    expect(second_buffet_owner.email).to eq 'second_buffet_owner@example.com'
  end

  it 'and see error messages when a field fails its validation' do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    login_as buffet_owner, scope: :buffet_owner
    visit new_buffet_path

    within 'main form' do
      fill_in 'Descrição',
        with: 'Oferecemos uma experiência gastronômica única.'

      click_on 'Criar Buffet'
    end

    expect(page).to have_content 'Preencha todos os campos corretamente ' \
                                 'para cadastrar o buffet.'

    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'

    expect(page)
      .to have_content 'CNPJ não possui o tamanho esperado (14 caracteres)'

    expect(page)
      .to have_content 'Telefone é muito curto (mínimo: 10 caracteres)'

    expect(page)
      .to have_content 'Estado não possui o tamanho esperado (2 caracteres)'

    expect(page)
      .to have_content 'CEP não possui o tamanho esperado (8 caracteres)'

    expect(page).to have_content 'CNPJ não é um número'
    expect(page).to have_content 'Telefone não é um número'
    expect(page).to have_content 'CEP não é um número'
  end

  it 'returning to home page if he already have a buffet' do
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
               buffet_owner: buffet_owner

    login_as buffet_owner, scope: :buffet_owner
    visit new_buffet_path

    expect(current_path).to eq root_path
  end

  it "returning to buffet owner sign in page if he isn't signed in" do
    visit new_buffet_path

    expect(current_path).to eq new_buffet_owner_session_path
  end

  it "returning to home page if he is a client" do
    client = Client
      .create! name: 'João da Silva',
               cpf: '11480076015',
               email: 'client@example.com',
               password: 'password'

    login_as client, scope: :client
    visit new_buffet_path

    expect(current_path).to eq root_path
  end
end