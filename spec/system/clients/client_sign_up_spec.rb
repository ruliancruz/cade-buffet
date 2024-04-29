require 'rails_helper'

describe 'Client sign up' do
  it 'from the menu' do
    visit root_path

    click_on 'Entrar'
    click_on 'Criar Nova Conta'

    expect(current_path).to eq new_client_registration_path

    within 'main form' do
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'CPF'
      expect(page).to have_field 'E-mail'
      expect(page).to have_field 'Senha'
      expect(page).to have_field 'Confirme sua senha'
      expect(page).to have_button 'Criar Nova Conta'
    end
  end

  it 'with success' do
    visit new_client_registration_path

    within 'main form' do
      fill_in 'Nome', with: 'User Name'
      fill_in 'CPF', with: '11480076015'
      fill_in 'E-mail', with: 'user@example.com'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      click_on 'Criar Nova Conta'
    end

    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    expect(page).to have_content 'user@example.com'
    expect(page).to have_content 'Sair'
  end

  it 'and return to home page if he is already signed in as a client' do
    user = Client.create! name: 'User Name',
                          cpf: '11480076015',
                          email: 'user@example.com',
                          password: 'password'

    login_as user, scope: :client
    visit new_client_registration_path

    expect(current_path).to eq root_path
  end

  it 'and return to home page if he is already signed in as a buffet owner' do
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

    login_as user, scope: :buffet_owner
    visit new_client_registration_path

    expect(current_path).to eq root_path
  end
end