require 'rails_helper'

RSpec.describe "New Item Creation" do
  it 'has a link from the merchant item index page' do
    merchant_1 = Merchant.create!(name: "Clothing Store")

    visit "/merchants/#{merchant_1.id}/items"

    click_link "Add New Item"

    expect(current_path).to eq("/merchants/#{merchant_1.id}/items/new")
  end

  it 'can create a new item' do
    merchant_1 = Merchant.create!(name: "Clothing Store")
    item_1 = merchant_1.items.create!(name: "Sweater", description: "Red Sweater", unit_price: 40)
    item_2 = merchant_1.items.create!(name: "Hat", description: "Beanie", unit_price: 20, status: 1)
    item_3 = merchant_1.items.create!(name: "Shoes", description: "Running Shoes", unit_price: 80)

    visit "/merchants/#{merchant_1.id}/items/new"

    fill_in('Name' , with: "Sweet T-Shirt")
    fill_in('Description' , with: "Blue T-shirt with Logo")
    fill_in('Unit price', with: 25)

    click_on("Submit")

    expect(current_path).to eq("/merchants/#{merchant_1.id}/items")

    visit "/merchants/#{merchant_1.id}/items"

    new_item = Item.last
    expect(new_item.name).to eq("Sweet T-Shirt")
    expect(page).to have_content(new_item.name)
    expect(new_item.status).to eq("disabled")
  end

  describe 'error message for incomplete new item form' do
    before(:each) do
      @merchant_1 = Merchant.create!(name: "Clothing Store")
      visit "/merchants/#{@merchant_1.id}/items/new"
    end

    it 'shows the user an error if the new form is not filled out with anything' do
      click_on("Submit")

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/items")

      expect(page).to have_content("Item not created")
      expect(page).to have_link("Add New Item")
    end

    it 'shows the user an error if the new form is not filled out with the name' do
      fill_in('Description' , with: "Blue T-shirt with Logo")
      fill_in('Unit price', with: 25)

      click_on("Submit")

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/items")

      expect(page).to have_content("Item not created")
      expect(page).to have_link("Add New Item")
    end

    it 'shows the user an error if the new form is not filled out with the description' do
      fill_in('Name' , with: "Sweet T-Shirt")
      fill_in('Unit price', with: 25)

      click_on("Submit")

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/items")

      expect(page).to have_content("Item not created")
      expect(page).to have_link("Add New Item")
    end

    it 'shows the user an error if the new form is not filled out with the unit price' do
      fill_in('Name' , with: "Sweet T-Shirt")
      fill_in('Description' , with: "Blue T-shirt with Logo")

      click_on("Submit")

      expect(current_path).to eq("/merchants/#{@merchant_1.id}/items")

      expect(page).to have_content("Item not created")
      expect(page).to have_link("Add New Item")
    end
  end
end
