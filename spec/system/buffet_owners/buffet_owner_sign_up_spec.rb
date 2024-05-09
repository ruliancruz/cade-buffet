require 'rails_helper'

describe 'Buffet owner sign up' do
  it 'from the menu' do
    visit root_path

    click_on 'Entrar'
    click_on 'Entrar Como Dono de Buffet'
    click_on 'Criar Nova Conta'

    expect(current_path).to eq new_buffet_owner_registration_path

    within 'main form' do
      expect(page).to have_field 'E-mail'
      expect(page).to have_field 'Senha'
      expect(page).to have_field 'Confirme sua senha'
      expect(page).to have_button 'Criar Nova Conta'
    end
  end

  it 'with success' do
    visit new_buffet_owner_registration_path

    within 'main form' do
      fill_in 'E-mail', with: 'buffet_owner@example.com'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      click_on 'Criar Nova Conta'
    end

    expect(page)
      .to have_content 'Boas vindas! Você realizou seu registro com sucesso.'

    expect(page).to have_content 'buffet_owner@example.com'
    expect(page).to have_content 'Sair'
  end

  it 'and return to home page if he is already signed in as a client' do
    client = Client.create! name: 'João da Silva',
                            cpf: '11480076015',
                            email: 'client@example.com',
                            password: 'password'

    login_as client, scope: :client
    visit new_buffet_owner_registration_path

    expect(current_path).to eq root_path
  end

  it 'and return to home page if he is already signed in as a buffet owner' do
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
    visit new_buffet_owner_registration_path

    expect(current_path).to eq root_path
  end
end