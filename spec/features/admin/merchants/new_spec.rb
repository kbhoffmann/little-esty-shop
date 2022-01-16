require 'rails_helper'

RSpec.describe 'admin merchant new page' do
  it 'can create a new merchant' do
    visit '/admin/merchants/new'
    fill_in('merchant_name', with: 'Glow Store')
    click_button('Add Merchant')

    expect(current_path).to eq('/admin/merchants')
    expect(page).to have_content('Glow Store')
  end
end
