require 'rails_helper'

RSpec.describe "New Item Creation" do
  let!(:merchant) {FactoryBot.create(:merchant)}
  before(:each) do
    visit "/merchants/#{merchant.id}/items/new"
  end

  it 'can create a new item' do
    fill_in('item[name]', with: "Sweet T-Shirt")
    fill_in('item[description]', with: "Blue T-shirt with Logo")
    fill_in('item[unit_price]', with: 2500)

    click_on("Submit")

    expect(current_path).to eq(merchant_items_path(merchant))
    expect(page).to have_content("Sweet T-Shirt")
  end

  it 'shows an error if form is submitted incomplete' do
    fill_in('item[name]', with: "Sweet T-Shirt")
    fill_in('item[unit_price]', with: 2500)

    click_on("Submit")

    expect(page).to have_content("Error")
    expect(current_path).to eq("/merchants/#{merchant.id}/items/new")
  end
end
