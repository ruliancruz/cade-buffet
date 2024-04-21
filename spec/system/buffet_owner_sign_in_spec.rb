require 'rails_helper'

describe 'Buffet owner sign in' do
  it 'with success' do
    BuffetOwner.create! email: 'user@example.com', password: 'password'

    visit root_path
    click_on 'Entrar'

    within 'form' do
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
    BuffetOwner.create! email: 'user@example.com', password: 'password'

    visit root_path
    click_on 'Entrar'

    within 'form' do
      fill_in 'E-mail', with: 'user@example.com'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end

    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso.'

    within 'nav' do
      expect(page).to have_link 'Entrar'
      expect(page).not_to have_button 'Sair'
      expect(page).not_to have_content 'user@example.com'
    end
  end
end