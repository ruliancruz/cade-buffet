require 'rails_helper'

describe 'Buffet owner edits the buffet' do
  it 'from the buffet page' do
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

    login_as user
    visit buffet_path 1
    click_on 'Alterar Dados'

    expect(current_path).to eq edit_buffet_path 1

    within 'h1' do
      expect(page).to have_content 'Atualize Seu Buffet'
    end

    within all("form")[1] do
      expect(page).to have_field 'Razão Social', with: 'Delícias Gastronômicas Ltda.'
      expect(page).to have_field 'Nome Fantasia', with: 'Sabor & Arte Buffet'
      expect(page).to have_field 'CNPJ', with: '12345678000190'
      expect(page).to have_field 'Telefone', with: '7531274464'
      expect(page).to have_field 'Endereço', with: 'Rua dos Sabores, 123'
      expect(page).to have_field 'Bairro', with: 'Centro'
      expect(page).to have_field 'Cidade', with: 'Culinária City'
      expect(page).to have_field 'Estado', with: 'BA'
      expect(page).to have_field 'CEP', with: '12345678'
      expect(page).to have_field 'Descrição', with: 'Oferecemos uma ' \
        'experiência gastronômica única.'

      expect(page).to have_button 'Atualizar Buffet'
    end
  end

  it 'with success' do
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

    login_as user
    visit buffet_path 1
    click_on 'Alterar Dados'

    within all("form")[1] do
      fill_in 'Razão Social', with: 'Delícias Gastronômicas'
      fill_in 'Nome Fantasia', with: 'Sabor e Arte Buffet'
      fill_in 'CNPJ', with: '12345678000191'
      fill_in 'Telefone', with: '7531274465'
      fill_in 'Endereço', with: 'Rua do Sabor, 125'
      fill_in 'Bairro', with: 'Batata'
      fill_in 'Cidade', with: 'Culinarilandia'
      fill_in 'Estado', with: 'PI'
      fill_in 'CEP', with: '12345679'
      fill_in 'Descrição', with: 'Oferecemos uma experiência gastronômica melhor.'
      click_on 'Atualizar Buffet'
    end

    expect(current_path).to eq buffet_path 1
    expect(page).to have_content 'Delícias Gastronômicas'
    expect(page).to have_content 'Sabor e Arte Buffet'
    expect(page).to have_content '12.345.678/0001-91'
    expect(page).to have_content '(75) 3127-4465'
    expect(page).to have_content 'Rua do Sabor, 125 - Batata, ' \
                                 'Culinarilandia - PI, 12345-679'

    expect(page).to have_content 'Oferecemos uma experiência gastronômica melhor.'
  end

  it 'and see error messages when a field fails its validation' do
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

    login_as user
    visit edit_buffet_path 1

    within all("form")[1] do
      fill_in 'Razão Social', with: ''
      fill_in 'Nome Fantasia', with: ''
      fill_in 'CNPJ', with: ''
      fill_in 'Telefone', with: ''
      fill_in 'Endereço', with: ''
      fill_in 'Bairro', with: ''
      fill_in 'Cidade', with: ''
      fill_in 'Estado', with: ''
      fill_in 'CEP', with: ''
      click_on 'Atualizar Buffet'
    end

    expect(page).to have_content 'Preencha todos os campos corretamente ' \
                                 'para atualizar o buffet.'

    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'Endereço não pode ficar em branco'
    expect(page).to have_content 'Cidade não pode ficar em branco'
    expect(page).to have_content 'Bairro não pode ficar em branco'
    expect(page).to have_content 'Estado não pode ficar em branco'
    expect(page).to have_content 'CEP não pode ficar em branco'

    expect(page).to have_content 'CNPJ não possui o tamanho esperado (14 caracteres)'
    expect(page).to have_content 'Telefone é muito curto (mínimo: 10 caracteres)'
    expect(page).to have_content 'Estado não possui o tamanho esperado (2 caracteres)'
    expect(page).to have_content 'CEP não possui o tamanho esperado (8 caracteres)'
    expect(page).to have_content 'CNPJ não é um número'
    expect(page).to have_content 'Telefone não é um número'
    expect(page).to have_content 'CEP não é um número'
  end

  it "returning to sign in page if he isn't signed in" do
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

    visit edit_buffet_path 1

    expect(current_path).to eq new_buffet_owner_session_path
  end

  it "returning to his own buffet page if he tries to edit another one buffet" do
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
                  district: 'Bairro Gourmet',
                  city: 'Saborville',
                  state: 'SP',
                  cep: '87654321',
                  description: 'Oferecemos uma experiência única.',
                  buffet_owner: another_user

    login_as user
    visit edit_buffet_path 2

    within all("form")[1] do
      expect(page).to have_field 'Razão Social', with: 'Delícias Gastronômicas Ltda.'
      expect(page).to have_field 'Nome Fantasia', with: 'Sabor & Arte Buffet'
      expect(page).to have_field 'CNPJ', with: '12345678000190'
      expect(page).to have_field 'Telefone', with: '7531274464'
      expect(page).to have_field 'Endereço', with: 'Rua dos Sabores, 123'
      expect(page).to have_field 'Bairro', with: 'Centro'
      expect(page).to have_field 'Cidade', with: 'Culinária City'
      expect(page).to have_field 'Estado', with: 'BA'
      expect(page).to have_field 'CEP', with: '12345678'
      expect(page).to have_field 'Descrição', with: 'Oferecemos uma ' \
        'experiência gastronômica única.'
    end
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet." do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    login_as user
    visit edit_buffet_path 1

    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end