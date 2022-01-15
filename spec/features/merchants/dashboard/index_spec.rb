require 'rails_helper'

RSpec.describe 'Merchant Dashboard' do

  let!(:merchant_1) {FactoryBot.create(:merchant, status: "disabled")}
  let!(:merchant_2) {FactoryBot.create(:merchant, status: "enabled")}
  let!(:merchant_3) {FactoryBot.create(:merchant, status: "enabled")}
  let!(:merchant_4) {FactoryBot.create(:merchant, status: "disabled")}
  let!(:merchant_5) {FactoryBot.create(:merchant)}
  let!(:merchant_6) {FactoryBot.create(:merchant)}
  let!(:merchant_7) {FactoryBot.create(:merchant)}

  let!(:item_1) {FactoryBot.create(:item, merchant_id: merchant_1.id, status: 0)}
  let!(:item_2) {FactoryBot.create(:item, merchant_id: merchant_2.id, status: 1)}
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
    visit "/merchants/#{merchant_1.id}/dashboard"
  end

  it 'shows the merchants name' do
    expect(page).to have_content(merchant_1.name)
  end

  it 'links to merchant items index' do
    click_link("Items")
    expect(current_path).to eq("/merchants/#{merchant_1.id}/items")
  end

  it 'links to merchant invoices index' do
    click_link("Invoices")
    expect(current_path).to eq("/merchants/#{merchant_1.id}/invoices")
  end

  it 'has a section for Items Ready to Ship' do
    expect(page).to have_content("Items Ready To Ship")
  end
end
