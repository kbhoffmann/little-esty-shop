require 'rails_helper'

RSpec.describe 'merchant invoice show page' do
  let!(:merchant_1) {FactoryBot.create(:merchant)}
  let!(:merchant_2) {FactoryBot.create(:merchant)}

  let!(:item_1) {FactoryBot.create(:item, merchant: merchant_1, unit_price: 100)}
  let!(:item_2) {FactoryBot.create(:item, merchant: merchant_1, unit_price: 50)}
  let!(:item_3) {FactoryBot.create(:item, merchant: merchant_1, unit_price: 300)}
  let!(:item_4) {FactoryBot.create(:item, merchant: merchant_2, unit_price: 400)}

  let!(:invoice_1) {FactoryBot.create(:invoice, status: 0)}
  let!(:invoice_2) {FactoryBot.create(:invoice, status: 1)}

  let!(:transaction_1) {FactoryBot.create(:transaction, invoice: invoice_1, credit_card_expiration_date: Date.today, result: 0)}

  let!(:invoice_item_1) {FactoryBot.create(:invoice_item, quantity: 100, unit_price: 100, item: item_1, invoice: invoice_1, status: 0)}
  let!(:invoice_item_2) {FactoryBot.create(:invoice_item, quantity: 50, unit_price: 50, item: item_2, invoice: invoice_1, status: 1)}

  let!(:invoice_item_3) {FactoryBot.create(:invoice_item, quantity: 300, unit_price: 300, item: item_3, invoice: invoice_2, status: 2)}
  let!(:invoice_item_4) {FactoryBot.create(:invoice_item, item: item_4)}

  let!(:discount) {Discount.create(merchant: merchant_1, amount: 0.1, threshold: 100)}
  before(:each) do
    visit merchant_invoice_path(merchant_1, invoice_1)
  end

  it 'shows invoice info' do
    expect(page).to have_content(invoice_1.id)
    expect(page).to have_content(invoice_1.status)
    expect(page).to have_content(invoice_1.created_at.strftime("%A, %B %d, %Y"))
    expect(page).to have_content(invoice_1.customer.first_name)
    expect(page).to have_content(invoice_1.customer.last_name)
  end

  it 'shows item name' do
    expect(page).to have_content(item_1.name)
    expect(page).to have_content(item_2.name)
  end

  it 'shows item quantity' do
    expect(page).to have_content(invoice_item_1.quantity)
    expect(page).to have_content(invoice_item_2.quantity)
  end

  it 'shows item unit price' do
    expect(page).to have_content(invoice_item_1.unit_price)
    expect(page).to have_content(invoice_item_2.unit_price)
  end

  it 'shows item status' do
    expect(page).to have_content(invoice_item_1.status)
    expect(page).to have_content(invoice_item_2.status)
  end

  it 'displays the total revenue for an invoice' do
    expect(page).to have_content("Total: $125.00")
  end

  it 'can update invoice status' do
    expect(page).to have_select(:invoice_status, selected: 'in progress')
    select 'completed', from: :invoice_status
    click_on "Update Invoice Status"
    expect(current_path).to eq(merchant_invoice_path(merchant_1, invoice_1))
    expect(page).to have_select(:invoice_status, selected: 'completed')
  end

  it 'can update item status' do
    within "#item-#{invoice_item_1.id}" do
      expect(page).to have_select(:invoice_item_status, selected: 'pending')
      select 'packaged', from: :invoice_item_status
      click_on "Update"
      expect(current_path).to eq(merchant_invoice_path(merchant_1, invoice_1))
      expect(page).to have_select(:invoice_item_status, selected: 'packaged')
    end
  end

  it 'shows total after discounts' do
    expect(page).to have_content("Total after discounts: $115.00")
  end

  it 'links to discount applied' do
    save_and_open_page
    click_link("#{discount.id}")
    expect(current_path).to eq(merchant_discount_path(merchant_1, discount))
  end


end
