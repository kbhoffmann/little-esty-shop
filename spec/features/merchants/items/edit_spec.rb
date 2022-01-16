require 'rails_helper'

RSpec.describe 'merchant item edit page' do
  before(:each) do
    @merchant_1 = Merchant.create!(name: "Parker")
    @merchant_2 = Merchant.create!(name: "Kerri")
    @item_1 = @merchant_1.items.create!(name: "Small Thing", description: "Its a thing that is small.", unit_price: 400)
    @item_2 = @merchant_1.items.create!(name: "Large Thing", description: "Its a thing that is large.", unit_price: 800)
    @item_3 = @merchant_2.items.create!(name: "Medium Thing", description: "Its a thing that is medium.", unit_price: 600)
    visit "/merchants/#{@merchant_1.id}/items/#{@item_1.id}/edit"
  end

  it 'can update item info' do
    fill_in 'item[name]', with: "Smallie"
    fill_in 'item[description]', with: "Smallmouth Bass"
    fill_in 'item[unit_price]', with: 40000
    click_button "Update Item"

    expect(current_path).to eq(merchant_item_path(@merchant_1, @item_1))

    expect(page).to have_content("Smallie")
    expect(page).to have_content("Smallmouth Bass")
    expect(page).to have_content("$400.00")
  end
end
