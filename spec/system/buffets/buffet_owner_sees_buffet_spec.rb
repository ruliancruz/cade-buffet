require 'rails_helper'

describe 'Buffet owner sees buffet page' do
  it 'of another buffet owner without add, edit and delete buttons' do
    first_buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second_buffet_owner@example.com',
               password: 'second-password'

    Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                   brand_name: 'Sabor & Arte Buffet',
                   cnpj: '34340299000145',
                   phone: '7531274464',
                   address: 'Rua dos Sabores, 123',
                   district: 'Centro',
                   city: 'Culinária City',
                   state: 'BA',
                   cep: '12345678',
                   description: 'Oferecemos uma experiência gastronômica ' \
                                'única.',
                   buffet_owner: first_buffet_owner

    second_buffet = Buffet
      .create! corporate_name: 'Sabores Deliciosos Ltda.',
               brand_name: 'Chef & Cia Buffet',
               cnpj: '96577377000187',
               phone: '9887654321',
               address: 'Avenida das Delícias, 456',
               district: 'Gourmet',
               city: 'Saborville',
               state: 'SP',
               cep: '87654321',
               description: 'Oferecemos uma experiência única.',
               buffet_owner: second_buffet_owner

    login_as first_buffet_owner, scope: :buffet_owner
    visit buffet_path second_buffet

    expect(current_path).to eq buffet_path second_buffet

    expect(page).to have_content 'Chef & Cia Buffet'
    expect(page).to have_content 'Oferecemos uma experiência única.'
    expect(page).to have_content '96.577.377/0001-87'
    expect(page).to have_content '(98) 8765-4321'

    expect(page).to have_content 'Avenida das Delícias, 456 - Gourmet, ' \
                                 'Saborville - SP, 87654-321'

    expect(page).not_to have_link 'Alterar Dados'
    expect(page).not_to have_link 'Adicionar Meio de Pagamento'
    expect(page).not_to have_link 'Adicionar Tipo de Evento'
    expect(page).not_to have_button 'Remover'
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    login_as buffet_owner, scope: :buffet_owner
    visit buffet_path 1

    expect(current_path).to eq new_buffet_path

    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end