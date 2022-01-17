require 'rails_helper'

RSpec.describe 'discount edit page' do
  let!(:merchant) {FactoryBot.create(:merchant)}

  let!(:discount) {Discount.create(amount: 20, threshold: 200, merchant: merchant)}

  before(:each) do
    visit "/merchants/#{merchant.id}/discounts/#{discount.id}/edit"
  end

  it 'can edit a discount' do
    fill_in 'discount[amount]', with: 10
    fill_in 'discount[threshold]', with: 100
    click_button 'Save changes'

    expect(current_path).to eq("/merchants/#{merchant.id}/discounts/#{discount.id}")
    expect(page).to have_content("10% off when ordering 100 or more of an item")
  end
end
