require 'rails_helper'

describe 'Buffet owner sign up' do
  it 'with success' do
    visit root_path

    click_on 'Entrar'
    click_on 'Criar nova conta'

    within 'form' do
      fill_in 'E-mail', with: 'user@example.com'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      click_on 'Criar nova conta'
    end

    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso.'
    expect(page).to have_content 'user@example.com'
    expect(page).to have_content 'Sair'
  end
end