require 'rails_helper'

describe 'Buffet owner register base-price' do
  it 'from the event type page' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                            brand_name: 'Sabor & Arte Buffet',
                            cnpj: '34340299000145',
                            phone: '7531274464',
                            address: 'Rua dos Sabores, 123',
                            district: 'Centro',
                            city: 'Culinária City',
                            state: 'BA',
                            cep: '12345678',
                            buffet_owner: user

    EventType.create! name: 'Coquetel de Networking Empresarial',
                      description: 'Um evento descontraído.',
                      minimum_attendees: 20,
                      maximum_attendees: 50,
                      duration: 120,
                      menu: 'Seleção de queijos, frutas e vinhos',
                      provides_alcohol_drinks: true,
                      provides_decoration: false,
                      provides_parking_service: false,
                      serves_external_address: false,
                      buffet: buffet

    login_as user, scope: :buffet_owner
    visit event_type_path 1
    click_on 'Adicionar Preço-base'

    expect(page).to have_content 'Adicionar Preço-base'

    within 'main form' do
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Valor Mínimo'
      expect(page).to have_field 'Adicional por Pessoa'
      expect(page).to have_field 'Valor por Hora Extra'
    end
  end

  it 'with success' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                            brand_name: 'Sabor & Arte Buffet',
                            cnpj: '34340299000145',
                            phone: '7531274464',
                            address: 'Rua dos Sabores, 123',
                            district: 'Centro',
                            city: 'Culinária City',
                            state: 'BA',
                            cep: '12345678',
                            buffet_owner: user

    event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                   description: 'Um evento descontraído.',
                                   minimum_attendees: 20,
                                   maximum_attendees: 50,
                                   duration: 120,
                                   menu: 'Seleção de queijos, frutas e vinhos',
                                   provides_alcohol_drinks: true,
                                   provides_decoration: true,
                                   provides_parking_service: false,
                                   serves_external_address: false,
                                   buffet: buffet

    login_as user, scope: :buffet_owner
    visit new_event_type_base_price_path(event_type)

    within 'main form' do
      fill_in 'Descrição', with: 'Meio de Semana'
      fill_in 'Valor Mínimo', with: 10_000
      fill_in 'Adicional por Pessoa', with: 250
      fill_in 'Valor por Hora Extra', with: 1_000
      click_on 'Criar Preço-base'
    end

    expect(current_path).to eq event_type_path 1
    expect(page).to have_content 'Meio de Semana'
    expect(page).to have_content 'Valor Mínimo: R$10.000,00'
    expect(page).to have_content 'Adicional por Pessoa: R$250,00'
    expect(page).to have_content 'Valor por Hora Extra: R$1.000,00'
    expect(BasePrice.last.event_type.name).to eq 'Coquetel de Networking Empresarial'
  end

  it 'and see error messages when a field fails its validation' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                            brand_name: 'Sabor & Arte Buffet',
                            cnpj: '34340299000145',
                            phone: '7531274464',
                            address: 'Rua dos Sabores, 123',
                            district: 'Centro',
                            city: 'Culinária City',
                            state: 'BA',
                            cep: '12345678',
                            buffet_owner: user

    event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                   description: 'Um evento descontraído.',
                                   minimum_attendees: 20,
                                   maximum_attendees: 50,
                                   duration: 120,
                                   menu: 'Seleção de queijos, frutas e vinhos',
                                   provides_alcohol_drinks: true,
                                   provides_decoration: true,
                                   provides_parking_service: false,
                                   serves_external_address: false,
                                   buffet: buffet

    login_as user, scope: :buffet_owner
    visit new_event_type_base_price_path(event_type)

    within 'main form' do
      fill_in 'Valor por Hora Extra', with: 1_000
      click_on 'Criar Preço-base'
    end

    expect(page).to have_content 'Preencha todos os campos corretamente ' \
                                 'para cadastrar o preço-base.'

    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Adicional por Pessoa não pode ficar em branco'
    expect(page).to have_content 'Valor Mínimo não pode ficar em branco'
    expect(page).to have_content 'Valor Mínimo não é um número'
    expect(page).to have_content 'Adicional por Pessoa não é um número'
  end

  it "returning to buffet owner sign in page if he isn't signed in" do
    visit new_event_type_base_price_path 1

    expect(current_path).to eq new_buffet_owner_session_path
  end

  it "returning to home page if he is a client" do
    user = Client.create! name: 'User',
                          cpf: '11480076015',
                          email: 'user@example.com',
                          password: 'password'

    login_as user, scope: :client
    visit new_event_type_base_price_path 1

    expect(current_path).to eq root_path
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet." do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    login_as user, scope: :buffet_owner
    visit new_event_type_base_price_path 1

    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end