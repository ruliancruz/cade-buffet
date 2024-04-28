require 'rails_helper'

describe 'User visits the homepage' do
  it 'and see registered buffets' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    another_user = BuffetOwner.create! email: 'another.user@example.com',
                                       password: 'another-password'

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

    Buffet.create! corporate_name: 'Sabores Deliciosos Ltda.',
                   brand_name: 'Chef & Cia Buffet',
                   cnpj: '08599251000146',
                   phone: '9887654321',
                   address: 'Avenida das Delícias, 456',
                   district: 'Bairro Gourmet',
                   city: 'Saborville',
                   state: 'SP',
                   cep: '87654321',
                   buffet_owner: another_user

    visit root_path

    expect(page).to have_content 'Cadê Buffet'
    expect(page).to have_content 'Sabor & Arte Buffet'
    expect(page).to have_content 'Culinária City - BA'
    expect(page).to have_content 'Chef & Cia Buffet'
    expect(page).to have_content 'Saborville - SP'
  end

  it 'and see a message if there is no buffet registered ' do
    visit root_path

    expect(page).to have_content 'Cadê Buffet'
    expect(page).to have_content 'Ainda não existem buffets cadastrados.'
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet." do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    login_as user
    visit root_path

    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end