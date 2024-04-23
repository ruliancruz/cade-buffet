require 'rails_helper'

describe 'Buffet owner register event type' do
  it 'from buffet page' do
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
    click_on 'Adicionar Tipo de Evento'

    expect(page).to have_content 'Adicione o Tipo de Evento'

    within all("form")[1] do
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Mínimo de Pessoas'
      expect(page).to have_field 'Máximo de Pessoas'
      expect(page).to have_field 'Duração'
      expect(page).to have_field 'Cardápio'
      expect(page).to have_content 'Opções Adicionais'
      expect(page).to have_field 'Fornece Bebidas Alcoólicas'
      expect(page).to have_field 'Fornece Decoração'
      expect(page).to have_field 'Fornece Serviço de Estacionamento'
      expect(page).to have_field 'Atende a Endereço Indicado por Cliente'
    end
  end

  it 'with success' do
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

    login_as user
    visit new_event_type_path

    within all("form")[1] do
      fill_in 'Nome', with: 'Coquetel de Networking Empresarial'
      fill_in 'Descrição', with: 'Um evento descontraído e profissional.'
      fill_in 'Mínimo de Pessoas', with: '20'
      fill_in 'Máximo de Pessoas', with: '50'
      fill_in 'Duração', with: '120'
      fill_in 'Cardápio', with: 'Seleção de queijos, frutas, vinhos e cupcakes'
      check 'Fornece Bebidas Alcoólicas'
      check 'Fornece Decoração'
      uncheck 'Fornece Serviço de Estacionamento'
      uncheck 'Atende a Endereço Indicado por Cliente'
      click_on 'Criar Tipo de Evento'
    end

    expect(current_path).to eq buffet_path 1
    expect(page).to have_content 'Coquetel de Networking Empresarial'
    expect(page).to have_content 'Um evento descontraído e profissional.'
    expect(EventType.last.buffet.brand_name).to eq 'Sabor & Arte Buffet'
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
    visit new_event_type_path
    click_on 'Criar Tipo de Evento'

    expect(page).to have_content 'Preencha todos os campos corretamente ' \
                                 'para adicionar o tipo de evento.'

    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Descrição não pode ficar em branco'
    expect(page).to have_content 'Mínimo de Pessoas não pode ficar em branco'
    expect(page).to have_content 'Máximo de Pessoas não pode ficar em branco'
    expect(page).to have_content 'Duração não pode ficar em branco'
    expect(page).to have_content 'Cardápio não pode ficar em branco'

    expect(page).to have_content 'Mínimo de Pessoas não é um número'
    expect(page).to have_content 'Máximo de Pessoas não é um número'
    expect(page).to have_content 'Duração não é um número'
  end

  it "returning to sign in page if he isn't signed in" do
    visit new_event_type_path

    expect(current_path).to eq new_buffet_owner_session_path
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
     "owner and hasn't registered his buffet yet." do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    login_as user
    visit new_event_type_path

    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end