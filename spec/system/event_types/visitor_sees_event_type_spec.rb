require 'rails_helper'

describe 'Visitor sees event type details' do
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

    event_type = EventType.new name: 'Coquetel de Networking Empresarial',
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

    event_type.photo.attach(io: File.open('spec/support/table.jpg'), filename: 'table.jpg', content_type: 'image/jpeg')
    event_type.save!

    BasePrice.create! description: 'Meio de Semana',
                      minimum: 10_000,
                      additional_per_person: 250,
                      extra_hour_value: 1_000,
                      event_type: event_type

    BasePrice.create! description: 'Final de Semana',
                      minimum: 14_000,
                      additional_per_person: 300,
                      extra_hour_value: 1_500,
                      event_type: event_type

    visit buffet_path 1
    click_on 'Coquetel de Networking Empresarial'

    expect(current_path).to eq event_type_path 1
    expect(page).to have_content 'Coquetel de Networking Empresarial'
    expect(page).to have_css('img[src*="table.jpg"]')
    expect(page).to have_content 'Um evento descontraído'
    expect(page).to have_content 'Mínimo de Pessoas: 20'
    expect(page).to have_content 'Máximo de Pessoas: 50'
    expect(page).to have_content 'Duração: 120 minutos'
    expect(page).to have_content 'Cardápio'
    expect(page).to have_content 'Seleção de queijos, frutas e vinhos'
    expect(page).to have_content 'Opções Adicionais'
    expect(page).to have_content 'Fornece Bebidas Alcoólicas: Sim'
    expect(page).to have_content 'Fornece Decoração: Sim'
    expect(page).to have_content 'Fornece Serviço de Estacionamento: Não'
    expect(page).to have_content 'Atende a Endereço Indicado por Cliente: Não'

    expect(page).to have_content 'Preços-base'
    expect(page).to have_content 'Meio de Semana'
    expect(page).to have_content 'R$10.000,00'
    expect(page).to have_content 'R$250,00'
    expect(page).to have_content 'R$1.000,00'
    expect(page).to have_content 'Final de Semana'
    expect(page).to have_content 'R$14.000,00'
    expect(page).to have_content 'R$300,00'
    expect(page).to have_content 'R$1.500,00'

    expect(page).not_to have_button 'Excluir'
    expect(page).not_to have_link 'Alterar Dados'
    expect(page).not_to have_link 'Remover'
    expect(page).not_to have_link 'Adicionar Preço-base'
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet." do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    login_as user, scope: :buffet_owner
    visit event_type_path 1

    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end