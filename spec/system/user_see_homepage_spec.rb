require 'rails_helper'

describe 'User visit homepage' do
  it "and see the app's name" do
    visit root_path

    expect(page).to have_content 'Cadê Buffet'
  end
end