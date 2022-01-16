require 'rails_helper'

RSpec.describe 'discount edit page' do
  let!(:merchant) {FactoryBot.create(:merchant)}

  let!(:discount) {Discount.create(amount: 0.2, threshold: 200, merchant: merchant)}

  before(:each) do
    visit "/merchants/#{merchant.id}/discounts/#{discount.id}/edit"
  end

  it 'can edit a discount' do
    fill_in 'discount[amount]', with: 0.1
    fill_in 'discount[threshold]', with: 100
    click_button 'Save changes'

    expect(current_path).to eq("/merchants/#{merchant.id}/discounts/#{discount.id}")
    expect(page).to have_content("10% off of 100 or more items")
  end
end
