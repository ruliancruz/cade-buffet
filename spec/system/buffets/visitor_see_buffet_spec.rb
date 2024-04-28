require 'rails_helper'

describe 'Visitor sees a buffet page' do
  it 'from the home page' do
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

    visit root_path
    click_on 'Sabor & Arte Buffet'

    expect(current_path).to eq buffet_path 1
    expect(page).to have_content 'Sabor & Arte Buffet'
    expect(page).to have_content 'Oferecemos uma experiência gastronômica única.'
    expect(page).to have_content '12.345.678/0001-90'
    expect(page).to have_content '(75) 3127-4464'
    expect(page).to have_content 'Rua dos Sabores, 123 - Centro, ' \
                                 'Culinária City - BA, 12345-678'
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet." do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    login_as user
    visit buffet_path 1

    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end