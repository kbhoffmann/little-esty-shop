require 'rails_helper'

RSpec.describe 'merchant discount index page' do
  let!(:merchant_a) {FactoryBot.create(:merchant)}
  let!(:merchant_b) {FactoryBot.create(:merchant)}

  let!(:discount_a) {Discount.create(amount: 0.2, threshold: 10, merchant: merchant_a)}
  let!(:discount_a2) {Discount.create(amount: 0.3, threshold: 15, merchant: merchant_b)}

  let!(:item_a1) {FactoryBot.create(:item, merchant: merchant_a)}
  let!(:item_a2) {FactoryBot.create(:item, merchant: merchant_a)}

  let!(:invoice_1) {FactoryBot.create(:invoice)}

  before(:each) do
    visit "/merchants/#{merchant_a.id}/discounts"
  end

  it 'shows each discount amount for merchant' do
    expect(page).to have_content("20% off")
    expect(page).to_not have_content("30% off")
  end

  it 'shows each discount quantity threshold for merchant' do
    expect(page).to have_content("of 10 items")
    expect(page).to_not have_content("of 15 items")
  end
end
