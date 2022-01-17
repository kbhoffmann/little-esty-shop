require 'rails_helper'

RSpec.describe 'merchant discount index page' do
  let!(:merchant_a) {FactoryBot.create(:merchant)}
  let!(:merchant_b) {FactoryBot.create(:merchant)}

  let!(:discount_a) {Discount.create(amount: 20, threshold: 10, merchant: merchant_a)}
  let!(:discount_a2) {Discount.create(amount: 30, threshold: 15, merchant: merchant_b)}

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
    expect(page).to have_content("10 or more of an item")
    expect(page).to_not have_content("15 or more of an item")
  end

  it 'shows 3 upcoming holidays' do
    within("#upcoming-holidays") do
      expect(page).to have_content("Martin Luther King, Jr. Day")
      expect(page).to have_content("Washington's Birthday")
      expect(page).to have_content("Good Friday")
    end
  end

  it 'has a link to create a new discount' do
    click_link("Add new discount")
    expect(current_path).to eq("/merchants/#{merchant_a.id}/discounts/new")
  end

  it 'can delete a discount' do
    within("#discount-#{discount_a.id}") do
      click_link("Delete")
    end
    expect(current_path).to eq("/merchants/#{merchant_a.id}/discounts")
    expect(page).to_not have_content("20% off when ordering 10 or more of an item")
  end
end
