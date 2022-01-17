require 'rails_helper'

RSpec.describe 'discount show page' do
  let!(:merchant) {FactoryBot.create(:merchant)}
  let!(:discount_1) {Discount.create!(merchant: merchant, amount: 30, threshold: 300)}
  let!(:discount_2) {Discount.create!(merchant: merchant, amount: 50, threshold: 500)}

  before(:each) do
    visit "/merchants/#{merchant.id}/discounts/#{discount_1.id}"
  end

  it 'shows discount information' do
    expect(page).to have_content("30% off when ordering 300 or more of an item")
    expect(page).to_not have_content("50% off when ordering 500 or more of an item")
  end

  it 'has a link to edit discount info' do
    click_link("Edit discount")
    expect(current_path).to eq("/merchants/#{merchant.id}/discounts/#{discount_1.id}/edit")
  end
end
