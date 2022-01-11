require 'rails_helper'

RSpec.describe 'admin merchants index' do
  let!(:merchant_1) {FactoryBot.create(:merchant, status: "disabled")}
  let!(:merchant_2) {FactoryBot.create(:merchant, status: "enabled")}
  let!(:merchant_3) {FactoryBot.create(:merchant, status: "enabled")}
  let!(:merchant_4) {FactoryBot.create(:merchant, status: "disabled")}
  let!(:merchant_5) {FactoryBot.create(:merchant)}
  let!(:merchant_6) {FactoryBot.create(:merchant)}
  let!(:merchant_7) {FactoryBot.create(:merchant)}

  let!(:item_1) {FactoryBot.create(:item, merchant_id: merchant_1.id)}
  let!(:item_2) {FactoryBot.create(:item, merchant_id: merchant_2.id)}
  let!(:item_3) {FactoryBot.create(:item, merchant_id: merchant_3.id)}
  let!(:item_4) {FactoryBot.create(:item, merchant_id: merchant_4.id)}
  let!(:item_5) {FactoryBot.create(:item, merchant_id: merchant_5.id)}
  let!(:item_6) {FactoryBot.create(:item, merchant_id: merchant_6.id)}
  let!(:item_7) {FactoryBot.create(:item, merchant_id: merchant_7.id)}

  let!(:transaction_1) {FactoryBot.create(:transaction, result: "success")}
  let!(:transaction_2) {FactoryBot.create(:transaction, result: "success")}
  let!(:transaction_3) {FactoryBot.create(:transaction, result: "success")}
  let!(:transaction_4) {FactoryBot.create(:transaction, result: "success")}
  let!(:transaction_5) {FactoryBot.create(:transaction, result: "success")}
  let!(:transaction_6) {FactoryBot.create(:transaction, result: "success")}
  let!(:transaction_7) {FactoryBot.create(:transaction, result: "success")}

  let!(:invoice_item_1) {FactoryBot.create(:invoice_item, invoice_id: transaction_1.invoice.id, item_id: item_1.id, quantity: 1, unit_price: 10)}
  let!(:invoice_item_2) {FactoryBot.create(:invoice_item, invoice_id: transaction_2.invoice.id, item_id: item_2.id, quantity: 2, unit_price: 10)}
  let!(:invoice_item_3) {FactoryBot.create(:invoice_item, invoice_id: transaction_3.invoice.id, item_id: item_3.id, quantity: 3, unit_price: 10)}
  let!(:invoice_item_4) {FactoryBot.create(:invoice_item, invoice_id: transaction_4.invoice.id, item_id: item_4.id, quantity: 4, unit_price: 10)}
  let!(:invoice_item_5) {FactoryBot.create(:invoice_item, invoice_id: transaction_5.invoice.id, item_id: item_5.id, quantity: 5, unit_price: 10)}
  let!(:invoice_item_6) {FactoryBot.create(:invoice_item, invoice_id: transaction_6.invoice.id, item_id: item_6.id, quantity: 6, unit_price: 10)}
  let!(:invoice_item_7) {FactoryBot.create(:invoice_item, invoice_id: transaction_7.invoice.id, item_id: item_7.id, quantity: 7, unit_price: 10)}
  before(:each) do
    visit '/admin/merchants'
  end

  it 'shows the name of all merchants' do
    expect(page).to have_content(merchant_1.name)
    expect(page).to have_content(merchant_2.name)
    expect(page).to have_content(merchant_3.name)
    expect(page).to have_content(merchant_4.name)
  end

  it 'can enable a merchant' do
    expect(merchant_1.status).to eq("disabled")
    within("#disabled-merchants") do
      within("#admin-merchant-#{merchant_1.id}") do
        click_button("Enable")
        expect(current_path).to eq("/admin/merchants")
      end
    end
    within("#enabled-merchants") do
      within("#admin-merchant-#{merchant_1.id}") do
        expect(page).to have_button("Disable")
      end
    end
  end

  it 'can disable a merchant' do
    expect(merchant_2.status).to eq("enabled")
    within("#enabled-merchants") do
      within("#admin-merchant-#{merchant_2.id}") do
        click_button("Disable")
        expect(current_path).to eq("/admin/merchants")
      end
    end
    within("#disabled-merchants") do
      within("#admin-merchant-#{merchant_2.id}") do
        expect(page).to have_button("Enable")
      end
    end
  end

  it 'has a section for enabled merchants' do
    within("#enabled-merchants") do
      expect(page).to have_content(merchant_2.name)
      expect(page).to have_content(merchant_3.name)
      expect(page).to_not have_content(merchant_1.name)
      expect(page).to_not have_content(merchant_4.name)
    end
  end

  it 'has a section for disabled merchants' do
    within("#disabled-merchants") do
      expect(page).to have_content(merchant_1.name)
      expect(page).to have_content(merchant_4.name)
      expect(page).to_not have_content(merchant_2.name)
      expect(page).to_not have_content(merchant_3.name)
    end
  end

  it 'has a link to create a new merchant on a new page' do
    expect(page).to have_link("Create a New Merchant", href: "/admin/merchants/new")
  end

  describe 'Top 5 Merchants Section' do
    it 'has a section for the top five merchants by total revenue' do
      expect(page).to have_content("Top Five Merchants By Revenue")
    end

    it 'has the names of each of the top 5 merchants' do
      within "#top-five-merchants" do
        expect(invoice_item_7.item.merchant.name).to appear_before(invoice_item_6.item.merchant.name)
        expect(invoice_item_6.item.merchant.name).to appear_before(invoice_item_5.item.merchant.name)
        expect(invoice_item_5.item.merchant.name).to appear_before(invoice_item_4.item.merchant.name)
        expect(invoice_item_4.item.merchant.name).to appear_before(invoice_item_3.item.merchant.name)
    end
    end
  end
end
