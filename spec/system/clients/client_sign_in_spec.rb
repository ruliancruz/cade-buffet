require 'rails_helper'

describe 'Client sign in' do
  it 'from the menu' do
    Client.create! name: 'User Name',
                   cpf: '11480076015',
                   email: 'user@example.com',
                   password: 'password'

    visit root_path
    click_on 'Entrar'

    expect(current_path).to eq new_client_session_path

    within 'main form' do
      expect(page).to have_field 'E-mail'
      expect(page).to have_field 'Senha'
      expect(page).to have_button 'Entrar'
    end
  end

  it 'with success' do
    Client.create! name: 'User Name',
                   cpf: '11480076015',
                   email: 'user@example.com',
                   password: 'password'

    visit new_client_session_path

    within 'main form' do
      fill_in 'E-mail', with: 'user@example.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end

    expect(page).to have_content 'Login efetuado com sucesso.'

    within 'nav' do
      expect(page).not_to have_link 'Entrar'
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'user@example.com'
    end
  end

  it 'and log out' do
    user = Client.create! name: 'User Name',
                          cpf: '11480076015',
                          email: 'user@example.com',
                          password: 'password'

    login_as user, scope: :client
    visit root_path
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso.'

    within 'nav' do
      expect(page).to have_link 'Entrar'
      expect(page).not_to have_button 'Sair'
      expect(page).not_to have_content 'user@example.com'
    end
  end

  it 'and return to home page if he is already signed in as a client' do
    user = Client.create! name: 'User Name',
                          cpf: '11480076015',
                          email: 'user@example.com',
                          password: 'password'

    login_as user, scope: :client
    visit new_client_session_path

    expect(current_path).to eq root_path
  end

  it 'and return to home page if he is already signed in as a buffet owner' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                   brand_name: 'Sabor & Arte Buffet',
                   cnpj: '34340299000145',
                   phone: '7531274464',
                   address: 'Rua dos Sabores, 123',
                   district: 'Centro',
                   city: 'Culinária City',
                   state: 'BA',
                   cep: '12345678',
                   buffet_owner: user

    login_as user, scope: :buffet_owner
    visit new_client_session_path

    expect(current_path).to eq root_path
  end
end