require 'rails_helper'

describe 'Buffet owner edits a base-price' do
  it 'from the buffet page' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                            brand_name: 'Sabor & Arte Buffet',
                            cnpj: '12345678000190',
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
                                   provides_decoration: false,
                                   provides_parking_service: false,
                                   serves_external_address: false,
                                   buffet: buffet

    BasePrice.create! description: 'Meio de Semana',
                      minimum: 10_000,
                      additional_per_person: 250,
                      extra_hour_value: 1_000,
                      event_type: event_type

    login_as user
    visit event_type_path 1
    click_on 'Meio de Semana'

    expect(current_path).to eq edit_base_price_path 1

    within 'h1' do
      expect(page).to have_content 'Editar Preço-base'
    end

    within 'main form' do
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Valor Mínimo'
      expect(page).to have_field 'Adicional por Pessoa'
      expect(page).to have_field 'Valor por Hora Extra'
      expect(page).to have_button 'Atualizar Preço-base'
    end
  end

  it 'with success' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                            brand_name: 'Sabor & Arte Buffet',
                            cnpj: '12345678000190',
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
                                   provides_decoration: false,
                                   provides_parking_service: false,
                                   serves_external_address: false,
                                   buffet: buffet

    BasePrice.create! description: 'Meio de Semana',
                      minimum: 10_000,
                      additional_per_person: 250,
                      extra_hour_value: 1_000,
                      event_type: event_type

    login_as user
    visit edit_base_price_path 1

    within 'main form' do
      fill_in 'Descrição', with: 'Meio de Semana'
      fill_in 'Valor Mínimo', with: 10_000
      fill_in 'Adicional por Pessoa', with: 250
      fill_in 'Valor por Hora Extra', with: 1_000
      click_on 'Atualizar Preço-base'
    end

    expect(current_path).to eq event_type_path 1
    expect(page).to have_content 'Meio de Semana'
    expect(page).to have_content 'Valor Mínimo: R$10.000,00'
    expect(page).to have_content 'Adicional por Pessoa: R$250,00'
    expect(page).to have_content 'Valor por Hora Extra: R$1.000,00'
  end

  it 'and see error messages when a field fails its validation' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                            brand_name: 'Sabor & Arte Buffet',
                            cnpj: '12345678000190',
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
                                   provides_decoration: false,
                                   provides_parking_service: false,
                                   serves_external_address: false,
                                   buffet: buffet

    BasePrice.create! description: 'Meio de Semana',
                      minimum: 10_000,
                      additional_per_person: 250,
                      extra_hour_value: 1_000,
                      event_type: event_type

    login_as user
    visit edit_base_price_path 1

    within 'main form' do
      fill_in 'Descrição', with: ''
      fill_in 'Valor Mínimo', with: ''
      fill_in 'Adicional por Pessoa', with: ''
      fill_in 'Valor por Hora Extra', with: 1_000
      click_on 'Atualizar Preço-base'
    end

    expect(page).to have_content 'Preencha todos os campos corretamente ' \
                                 'para atualizar o preço-base.'

    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Valor Mínimo não pode ficar em branco'
    expect(page).to have_content 'Adicional por Pessoa não pode ficar em branco'
    expect(page).to have_content 'Valor Mínimo não é um número'
    expect(page).to have_content 'Adicional por Pessoa não é um número'
  end

  it 'returning to his own buffet page if he tries to access another one ' \
     'base price edition page' do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    another_user = BuffetOwner.create! email: 'another.user@example.com',
                                       password: 'another-password'

    buffet = Buffet.create! corporate_name: 'Sabores Deliciosos Ltda.',
                            brand_name: 'Chef & Cia Buffet',
                            cnpj: '08599251000146',
                            phone: '9887654321',
                            address: 'Avenida das Delícias, 456',
                            district: 'Gourmet',
                            city: 'Saborville',
                            state: 'SP',
                            cep: '87654321',
                            buffet_owner: user

    another_buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                                    brand_name: 'Sabor & Arte Buffet',
                                    cnpj: '12345678000190',
                                    phone: '7531274464',
                                    address: 'Rua dos Sabores, 123',
                                    district: 'Centro',
                                    city: 'Culinária City',
                                    state: 'BA',
                                    cep: '12345678',
                                    buffet_owner: another_user

    event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
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

    another_event_type = EventType.create! name: 'Festa de Aniversário infantil',
                                           description: 'Um evento muito legal.',
                                           minimum_attendees: 10,
                                           maximum_attendees: 40,
                                           duration: 80,
                                           menu: 'Bolos, salgados e sucos',
                                           provides_alcohol_drinks: false,
                                           provides_decoration: true,
                                           provides_parking_service: false,
                                           serves_external_address: true,
                                           buffet: another_buffet

    BasePrice.create! description: 'Meio de Semana',
                      minimum: 10_000,
                      additional_per_person: 250,
                      extra_hour_value: 1_000,
                      event_type: event_type

    BasePrice.create! description: 'Final de Semana',
                      minimum: 14_000,
                      additional_per_person: 300,
                      extra_hour_value: 1_500,
                      event_type: another_event_type

    login_as user
    visit edit_base_price_path 2

    expect(current_path).to eq buffet_path 1
    expect(page).to have_content 'Sabores Deliciosos Ltda.'
  end

  it "returning to sign in page if he isn't signed in" do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                            brand_name: 'Sabor & Arte Buffet',
                            cnpj: '12345678000190',
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
                                   provides_decoration: false,
                                   provides_parking_service: false,
                                   serves_external_address: false,
                                   buffet: buffet

    BasePrice.create! description: 'Meio de Semana',
                      minimum: 10_000,
                      additional_per_person: 250,
                      extra_hour_value: 1_000,
                      event_type: event_type

    visit edit_base_price_path 1

    expect(current_path).to eq new_buffet_owner_session_path
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet." do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    login_as user
    visit edit_base_price_path 1

    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end