require 'rails_helper'

RSpec.describe 'discount show page' do
  let!(:merchant) {FactoryBot.create(:merchant)}
  let!(:discount_1) {Discount.create!(merchant: merchant, amount: 0.3, threshold: 300)}
  let!(:discount_2) {Discount.create!(merchant: merchant, amount: 0.5, threshold: 500)}

  before(:each) do
    visit "/merchants/#{merchant.id}/discounts/#{discount_1.id}"
  end

  it 'shows discount information' do
    expect(page).to have_content("30% off of 300 or more items")
    expect(page).to_not have_content("50% off of 500 or more items")
  end

  it 'has a link to edit discount info' do
    click_link("Edit discount")
    expect(current_path).to eq("/merchants/#{merchant.id}/discounts/#{discount_1.id}/edit")
  end 
end
