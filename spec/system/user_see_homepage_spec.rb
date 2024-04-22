require 'rails_helper'

describe 'User visits the homepage' do
  it "and see the app's name" do
    visit root_path

    expect(page).to have_content 'Cadê Buffet'
  end

  it "and is redirected to the buffet registration page if he is a buffet " \
    "owner and hasn't registered his buffet yet." do
    user = BuffetOwner.create! email: 'user@example.com', password: 'password'

    login_as user
    visit root_path

    expect(current_path).to eq new_buffet_path
    expect(page).to have_content 'Você precisa cadastrar seu buffet antes ' \
                                 'de acessar outras páginas'
  end
end