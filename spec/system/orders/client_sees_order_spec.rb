require 'rails_helper'

describe 'client sees an order' do
  it 'from the orders page' do
    buffet_owner = BuffetOwner.create! email: 'user@example.com', password: 'password'

    client = Client.create! name: 'Client',
                            cpf: '11480076015',
                            email: 'client@example.com',
                            password: 'client-password'

    buffet = Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                            brand_name: 'Sabor & Arte Buffet',
                            cnpj: '34340299000145',
                            phone: '7531274464',
                            address: 'Rua dos Sabores, 123',
                            district: 'Centro',
                            city: 'Culinária City',
                            state: 'BA',
                            cep: '12345678',
                            buffet_owner: buffet_owner

    first_event_type = EventType.create! name: 'Coquetel de Networking Empresarial',
                                         description: 'Um evento descontraído.',
                                         minimum_attendees: 20,
                                         maximum_attendees: 50,
                                         duration: 120,
                                         menu: 'Seleção de queijos, frutas e vinhos',
                                         provides_alcohol_drinks: true,
                                         provides_decoration: false,
                                         provides_parking_service: false,
                                         serves_external_address: true,
                                         buffet: buffet

    second_event_type = EventType.create! name: 'Festa de Aniversário infantil',
                                          description: 'Um evento muito legal.',
                                          minimum_attendees: 10,
                                          maximum_attendees: 40,
                                          duration: 80,
                                          menu: 'Bolos, salgados, sucos e refrigerantes',
                                          provides_alcohol_drinks: false,
                                          provides_decoration: true,
                                          provides_parking_service: false,
                                          serves_external_address: true,
                                          buffet: buffet

    BasePrice.create! description: 'Meio de Semana',
                      minimum: 10_000,
                      additional_per_person: 250,
                      extra_hour_value: 1_000,
                      event_type: first_event_type

    BasePrice.create! description: 'Final de Semana',
                      minimum: 14_000,
                      additional_per_person: 300,
                      extra_hour_value: 1_500,
                      event_type: second_event_type

    first_order = Order.new date: I18n.localize(Date.current + 2.week),
                            attendees: 40,
                            details: 'Quero que inclua queijo suíço e vinho tinto.',
                            address: buffet.full_address,
                            status: :waiting_for_evaluation,
                            event_type: first_event_type,
                            client: client

    first_order.generate_code
    first_order.save!

    second_order = Order.new date: I18n.localize(Date.current + 3.week),
                             attendees: 30,
                             details: 'Quero que inclua coxinhas e pasteis.',
                             address: buffet.full_address,
                             status: :waiting_for_evaluation,
                             event_type: second_event_type,
                             client: client

    second_order.generate_code
    second_order.save!

    login_as client, scope: :client
    visit orders_path
    click_on first_order.code

    expect(current_path).to eq order_path first_order
    expect(page).to have_content first_order.code
    expect(page).to have_content 'Aguardando avaliação do buffet'
    expect(page).to have_content I18n.l(Date.current + 2.week)
    expect(page).to have_content '40'
    expect(page).to have_content 'Rua dos Sabores, 123 - Centro, Culinária City - BA'
    expect(page).to have_content 'A combinar'
    expect(page).to have_link 'Coquetel de Networking Empresarial'
    expect(page).to have_link 'Sabor & Arte Buffet'
    expect(page).not_to have_content second_order.code
    expect(page).not_to have_content I18n.l(Date.current + 3.week)
    expect(page).not_to have_link 'Festa de Aniversário infantil'
  end

  it "and returns to client sign in page if he isn't signed in" do
    visit order_path 1

    expect(current_path).to eq new_client_session_path
  end

  it "and returns to home page if he is a buffet owner" do
    buffet_owner = BuffetOwner.create! email: 'user@example.com', password: 'password'

    Buffet.create! corporate_name: 'Delícias Gastronômicas Ltda.',
                   brand_name: 'Sabor & Arte Buffet',
                   cnpj: '34340299000145',
                   phone: '7531274464',
                   address: 'Rua dos Sabores, 123',
                   district: 'Centro',
                   city: 'Culinária City',
                   state: 'BA',
                   cep: '12345678',
                   buffet_owner: buffet_owner

    login_as buffet_owner, scope: :buffet_owner
    visit order_path 1

    expect(current_path).to eq root_path
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet" do
    buffet_owner = BuffetOwner.create! email: 'user@example.com', password: 'password'

    login_as buffet_owner, scope: :buffet_owner
    visit order_path 1

    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end