require 'rails_helper'

describe 'Visitor sees buffet details' do
  it 'with success' do
    buffet_owner = BuffetOwner
      .create! email: 'buffet_owner@example.com', password: 'password'

    buffet = Buffet
      .create! corporate_name: 'Delícias Gastronômicas Ltda.',
               brand_name: 'Sabor & Arte Buffet',
               cnpj: '34340299000145',
               phone: '7531274464',
               address: 'Rua dos Sabores, 123',
               district: 'Centro',
               city: 'Culinária City',
               state: 'BA',
               cep: '12345678',
               description: 'Oferecemos uma experiência gastronômica única.',
               buffet_owner: buffet_owner

    first_event_type = EventType
      .new name: 'Coquetel de Networking Empresarial',
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

    first_event_type.photo
      .attach(io: File.open( 'spec/support/table.jpg'),
              filename: 'table.jpg', content_type: 'image/jpeg')

    first_event_type.save!

    second_event_type = EventType
      .new name: 'Coquetel de Aniversário',
           description: 'Um evento de para comemorar.',
           minimum_attendees: 10,
           maximum_attendees: 40,
           duration: 100,
           menu: 'Seleção de queijos, carnes, vinhos e hidromel',
           provides_alcohol_drinks: true,
           provides_decoration: false,
           provides_parking_service: false,
           serves_external_address: true,
           buffet: buffet

    second_event_type.photo
      .attach(io: File.open('spec/support/anniversary.jpg'),
              filename: 'anniversary.jpg', content_type: 'image/jpeg')

    second_event_type.save!

    PaymentOption.create! name: 'Cartão de Crédito',
                          installment_limit: 12,
                          buffet: buffet

    PaymentOption.create! name: 'Pix',
                          installment_limit: 1,
                          buffet: buffet

    visit root_path
    click_on 'Sabor & Arte Buffet'

    expect(current_path).to eq buffet_path buffet

    expect(page).not_to have_content 'Delícias Gastronômicas Ltda.'
    expect(page).to have_content 'Sabor & Arte Buffet'

    expect(page)
      .to have_content 'Oferecemos uma experiência gastronômica única.'

    expect(page).to have_content '34.340.299/0001-45'
    expect(page).to have_content '(75) 3127-4464'

    expect(page).to have_content 'Rua dos Sabores, 123 - Centro, ' \
                                 'Culinária City - BA, 12345-678'

    expect(page).to have_content 'Cartão de Crédito'
    expect(page).to have_content 'Parcela em até 12x'
    expect(page).to have_content 'Pix'
    expect(page).to have_content 'À vista'

    expect(page).to have_content 'Coquetel de Networking Empresarial'
    expect(page).to have_css 'img[src*="table.jpg"]'
    expect(page).to have_content 'Um evento descontraído.'
    expect(page).to have_content 'Coquetel de Aniversário'
    expect(page).to have_css 'img[src*="anniversary.jpg"]'
    expect(page).to have_content 'Um evento de para comemorar.'

    expect(page).not_to have_button 'Remover'
    expect(page).not_to have_link 'Alterar Dados'
    expect(page).not_to have_link 'Adicionar Meio de Pagamento'
    expect(page).not_to have_link 'Adicionar Tipo de Evento'
  end
end