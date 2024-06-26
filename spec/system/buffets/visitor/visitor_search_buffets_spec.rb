require 'rails_helper'

describe 'Visitor search for buffets' do
  it 'from the menu' do
    visit root_path

    within "header nav" do
      expect(page).to have_field 'query'
      expect(page).to have_button 'Buscar'
    end
  end

  it 'and find buffets by brand name' do
    first_buffet_owner = BuffetOwner
      .create! email: 'first.buffet_owner@example.com',
               password: 'first-password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second.buffet_owner@example.com',
               password: 'second-password'

    third_buffet_owner = BuffetOwner
      .create! email: 'third.buffet_owner@example.com',
               password: 'third-password'

    Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                   brand_name: 'Sabor & Arte Buffet',
                   cnpj: '34340299000145',
                   phone: '7531274464',
                   address: 'Rua dos Sabores, 123',
                   district: 'Centro',
                   city: 'Culinária City',
                   state: 'BA',
                   cep: '12345678',
                   buffet_owner: first_buffet_owner

    Buffet.create! corporate_name: 'Sabores Deliciosos Ltda.',
                   brand_name: 'Sabor & Cia Buffet',
                   cnpj: '96577377000187',
                   phone: '9887654321',
                   address: 'Avenida das Delícias, 456',
                   district: 'Bairro Gourmet',
                   city: 'Saborville',
                   state: 'SP',
                   cep: '87654321',
                   buffet_owner: second_buffet_owner

    Buffet.create! corporate_name: 'Doces Açucarados Ltda.',
                   brand_name: 'Doce & Cia Buffet',
                   cnpj: '88673550000112',
                   phone: '9877654123',
                   address: 'Caminho dos Doces, 456',
                   district: 'Bairro do Mel',
                   city: 'Saborville',
                   state: 'SP',
                   cep: '87654300',
                   buffet_owner: third_buffet_owner

    visit root_path

    within "header nav" do
      fill_in 'query', with: 'Sabor &'
      click_on 'Buscar'
    end

    expect(page).to have_content "Resultados da busca por: Sabor &"
    expect(page).to have_content "2 buffets encontrados"
    expect(page).to have_content 'Sabor & Arte Buffet'
    expect(page).to have_content 'Culinária City - BA'
    expect(page).to have_content 'Sabor & Cia Buffet'
    expect(page).to have_content 'Saborville - SP'

    expect(page).not_to have_content 'Doce & Cia Buffet'
  end

  it 'and find buffets by city' do
    first_buffet_owner = BuffetOwner
      .create! email: 'first.buffet_owner@example.com',
               password: 'first-password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second.buffet_owner@example.com',
               password: 'second-password'

    third_buffet_owner = BuffetOwner
      .create! email: 'third.buffet_owner@example.com',
               password: 'third-password'

    Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                   brand_name: 'Sabor & Arte Buffet',
                   cnpj: '34340299000145',
                   phone: '7531274464',
                   address: 'Rua dos Sabores, 123',
                   district: 'Centro',
                   city: 'Culinária City',
                   state: 'BA',
                   cep: '12345678',
                   buffet_owner: first_buffet_owner

    Buffet.create! corporate_name: 'Sabores Deliciosos Ltda.',
                   brand_name: 'Sabor & Cia Buffet',
                   cnpj: '96577377000187',
                   phone: '9887654321',
                   address: 'Avenida das Delícias, 456',
                   district: 'Bairro Gourmet',
                   city: 'Saborville',
                   state: 'SP',
                   cep: '87654321',
                   buffet_owner: second_buffet_owner

    Buffet.create! corporate_name: 'Doces Açucarados Ltda.',
                   brand_name: 'Doce & Cia Buffet',
                   cnpj: '88673550000112',
                   phone: '9877654123',
                   address: 'Caminho dos Doces, 456',
                   district: 'Bairro do Mel',
                   city: 'Saborville',
                   state: 'SP',
                   cep: '87654300',
                   buffet_owner: third_buffet_owner

    visit root_path

    within "header nav" do
      fill_in 'query', with: 'Saborville'
      click_on 'Buscar'
    end

    expect(page).to have_content "Resultados da busca por: Saborville"
    expect(page).to have_content "2 buffets encontrados"
    expect(page).to have_content 'Doce & Cia Buffet'
    expect(page).to have_content 'Sabor & Cia Buffet'
    expect(page).to have_content 'Saborville - SP'
    expect(page).not_to have_content 'Sabor & Arte Buffet'
    expect(page).not_to have_content 'Culinária City - BA'
  end

  it 'and find buffets by event type' do
    first_buffet_owner = BuffetOwner
      .create! email: 'first.buffet_owner@example.com',
               password: 'first-password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second.buffet_owner@example.com',
               password: 'second-password'

    third_buffet_owner = BuffetOwner
      .create! email: 'third.buffet_owner@example.com',
               password: 'third-password'

    first_buffet = Buffet
      .create! corporate_name: 'Delícias Gastronômicas Ltda.',
               brand_name: 'Sabor & Arte Buffet',
               cnpj: '34340299000145',
               phone: '7531274464',
               address: 'Rua dos Sabores, 123',
               district: 'Centro',
               city: 'Culinária City',
               state: 'BA',
               cep: '12345678',
               buffet_owner: first_buffet_owner

    second_buffet = Buffet
      .create! corporate_name: 'Sabores Deliciosos Ltda.',
               brand_name: 'Sabor & Cia Buffet',
               cnpj: '96577377000187',
               phone: '9887654321',
               address: 'Avenida das Delícias, 456',
               district: 'Bairro Gourmet',
               city: 'Saborville',
               state: 'SP',
               cep: '87654321',
               buffet_owner: second_buffet_owner

    third_buffet = Buffet
      .create! corporate_name: 'Doces Açucarados Ltda.',
               brand_name: 'Doce & Cia Buffet',
               cnpj: '88673550000112',
               phone: '9877654123',
               address: 'Caminho dos Doces, 456',
               district: 'Bairro do Mel',
               city: 'Saborville',
               state: 'SP',
               cep: '87654300',
               buffet_owner: third_buffet_owner

    EventType
      .create! name: 'Coquetel de Networking Empresarial',
               description: 'Um evento descontraído.',
               minimum_attendees: 20,
               maximum_attendees: 50,
               duration: 120,
               menu: 'Seleção de queijos, frutas e vinhos',
               provides_alcohol_drinks: true,
               provides_decoration: false,
               provides_parking_service: false,
               serves_external_address: false,
               buffet: first_buffet

    EventType
      .create! name: 'Coquetel de Aniversário',
               description: 'Um evento de para comemorar.',
               minimum_attendees: 10,
               maximum_attendees: 40,
               duration: 100,
               menu: 'Seleção de queijos, carnes, vinhos e hidromel',
               provides_alcohol_drinks: true,
               provides_decoration: false,
               provides_parking_service: false,
               serves_external_address: true,
               buffet: first_buffet

    EventType
      .create! name: 'Festa de Aniversário infantil',
               description: 'Um evento fabuloso.',
               minimum_attendees: 10,
               maximum_attendees: 40,
               duration: 80,
               menu: 'Bolo, salgados, sucos e refrigerantes',
               provides_alcohol_drinks: false,
               provides_decoration: true,
               provides_parking_service: false,
               serves_external_address: true,
               buffet: second_buffet

    EventType
      .create! name: 'Festa de Aniversário de 15 anos',
               description: 'Um evento inesquecível.',
               minimum_attendees: 15,
               maximum_attendees: 50,
               duration: 140,
               menu: 'Bolo, salgados, sucos e refrigerantes',
               provides_alcohol_drinks: false,
               provides_decoration: true,
               provides_parking_service: false,
               serves_external_address: true,
               buffet: second_buffet

    EventType
      .create! name: 'Festa de Casamento',
               description: 'Um casamento fabuloso.',
               minimum_attendees: 30,
               maximum_attendees: 80,
               duration: 150,
               menu: 'Bolo, coquetéis, risoto, bobó de camarão e lasanha',
               provides_alcohol_drinks: true,
               provides_decoration: true,
               provides_parking_service: true,
               serves_external_address: false,
               buffet: third_buffet

    EventType
      .create! name: 'Super Evento de Casamento',
               description: 'Um casamento muito mais fabuloso.',
               minimum_attendees: 50,
               maximum_attendees: 150,
               duration: 200,
               menu: 'Bolo gigante, coquetéis, risoto e bobó de camarão',
               provides_alcohol_drinks: true,
               provides_decoration: true,
               provides_parking_service: true,
               serves_external_address: false,
               buffet: third_buffet

    visit root_path

    within "header nav" do
      fill_in 'query', with: 'Aniversário'
      click_on 'Buscar'
    end

    expect(page).to have_content "Resultados da busca por: Aniversário"
    expect(page).to have_content "2 buffets encontrados"
    expect(page).to have_content 'Sabor & Arte Buffet'
    expect(page).to have_content 'Culinária City - BA'
    expect(page).to have_content 'Sabor & Cia Buffet'
    expect(page).to have_content 'Saborville - SP'

    expect(page).not_to have_content 'Doce & Cia Buffet'
  end

  it 'and see the result in alphabetical brand name order' do
    first_buffet_owner = BuffetOwner
      .create! email: 'first.buffet_owner@example.com',
               password: 'first-password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second.buffet_owner@example.com',
               password: 'second-password'

    third_buffet_owner = BuffetOwner
      .create! email: 'third.buffet_owner@example.com',
               password: 'third-password'

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
               buffet_owner: first_buffet_owner

    Buffet
      .create! corporate_name: 'Sabores Deliciosos Ltda.',
               brand_name: 'Sabor & Cia Buffet',
               cnpj: '96577377000187',
               phone: '9887654321',
               address: 'Avenida das Delícias, 456',
               district: 'Bairro Gourmet',
               city: 'Saborville',
               state: 'SP',
               cep: '87654321',
               buffet_owner: second_buffet_owner

    Buffet
      .create! corporate_name: 'Doces Açucarados Ltda.',
               brand_name: 'Doce & Cia Buffet',
               cnpj: '88673550000112',
               phone: '9877654123',
               address: 'Caminho dos Doces, 456',
               district: 'Bairro do Mel',
               city: 'Saborville',
               state: 'SP',
               cep: '87654300',
               buffet_owner: third_buffet_owner

    visit search_buffets_path query: '&'

    within '.card:nth-child(1)' do
      expect(page).to have_content 'Doce & Cia Buffet'
    end

    within '.card:nth-child(2)' do
      expect(page).to have_content 'Sabor & Arte Buffet'
    end

    within '.card:nth-child(3)' do
      expect(page).to have_content 'Sabor & Cia Buffet'
    end
  end

  it 'and go to the buffet details page' do
    first_buffet_owner = BuffetOwner
      .create! email: 'first.buffet_owner@example.com',
               password: 'first-password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second.buffet_owner@example.com',
               password: 'second-password'

    third_buffet_owner = BuffetOwner
      .create! email: 'third.buffet_owner@example.com',
               password: 'third-password'

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
               buffet_owner: first_buffet_owner

    second_buffet = Buffet
      .create! corporate_name: 'Sabores Deliciosos Ltda.',
               brand_name: 'Sabor & Cia Buffet',
               cnpj: '96577377000187',
               phone: '9887654321',
               address: 'Avenida das Delícias, 456',
               district: 'Bairro Gourmet',
               city: 'Saborville',
               state: 'SP',
               cep: '87654321',
               buffet_owner: second_buffet_owner

    Buffet
      .create! corporate_name: 'Doces Açucarados Ltda.',
               brand_name: 'Doce & Cia Buffet',
               cnpj: '88673550000112',
               phone: '9877654123',
               address: 'Caminho dos Doces, 456',
               district: 'Bairro do Mel',
               city: 'Saborville',
               state: 'SP',
               cep: '87654300',
               buffet_owner: third_buffet_owner

    visit search_buffets_path query: 'Sabor &'
    click_on 'Sabor & Cia Buffet'

    expect(current_path).to eq buffet_path second_buffet

    expect(page).to have_content 'Sabor & Cia Buffet'
    expect(page).to have_content '96.577.377/0001-87'
    expect(page).not_to have_content 'Sabores Deliciosos Ltda.'
  end

  it 'and sees a message if the search returns nothing' do
    first_buffet_owner = BuffetOwner
      .create! email: 'first.buffet_owner@example.com',
               password: 'first-password'

    second_buffet_owner = BuffetOwner
      .create! email: 'second.buffet_owner@example.com',
               password: 'second-password'

    third_buffet_owner = BuffetOwner
      .create! email: 'third.buffet_owner@example.com',
               password: 'third-password'

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
               buffet_owner: first_buffet_owner

    Buffet
      .create! corporate_name: 'Sabores Deliciosos Ltda.',
               brand_name: 'Sabor & Cia Buffet',
               cnpj: '96577377000187',
               phone: '9887654321',
               address: 'Avenida das Delícias, 456',
               district: 'Bairro Gourmet',
               city: 'Saborville',
               state: 'SP',
               cep: '87654321',
               buffet_owner: second_buffet_owner

    Buffet
      .create! corporate_name: 'Doces Açucarados Ltda.',
               brand_name: 'Doce & Cia Buffet',
               cnpj: '88673550000112',
               phone: '9877654123',
               address: 'Caminho dos Doces, 456',
               district: 'Bairro do Mel',
               city: 'Saborville',
               state: 'SP',
               cep: '87654300',
               buffet_owner: third_buffet_owner

    visit root_path

    within "header nav" do
      fill_in 'query', with: 'Buffet Ruby on Rails'
      click_on 'Buscar'
    end

    expect(page)
      .to have_content "Resultados da busca por: Buffet Ruby on Rails"

    expect(page).to have_content "Nenhum buffet encontrado."

    expect(page).not_to have_content 'Doce & Cia Buffet'
    expect(page).not_to have_content 'Saborville - SP'
    expect(page).not_to have_content 'Sabor & Arte Buffet'
    expect(page).not_to have_content 'Culinária City - BA'
    expect(page).not_to have_content 'Sabor & Cia Buffet'
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet" do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    login_as buffet_owner, scope: :buffet_owner
    visit search_buffets_path query: '&'

    expect(current_path).to eq new_buffet_path

    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end