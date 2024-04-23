require 'rails_helper'

describe 'Buffet owner sees buffet page' do
  it 'of another buffet owner' do
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
                   description: 'Oferecemos uma experiência gastronômica única.',
                   buffet_owner: user

    Buffet.create! corporate_name: 'Sabores Deliciosos Ltda.',
                   brand_name: 'Chef & Cia Buffet',
                   cnpj: '08599251000146',
                   phone: '9887654321',
                   address: 'Avenida das Delícias, 456',
                   district: 'Gourmet',
                   city: 'Saborville',
                   state: 'SP',
                   cep: '87654321',
                   description: 'Oferecemos uma experiência única.',
                   buffet_owner: another_user

    login_as user
    visit buffet_path 2

    expect(current_path).to eq buffet_path 2
    expect(page).to have_content 'Sabores Deliciosos Ltda.'
    expect(page).to have_content 'Chef & Cia Buffet'
    expect(page).to have_content '08.599.251/0001-46'
    expect(page).to have_content '(98) 8765-4321'
    expect(page).to have_content 'Avenida das Delícias, 456 - Gourmet, ' \
                                 'Saborville - SP, 87654-321'

    expect(page).to have_content 'Oferecemos uma experiência única.'
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