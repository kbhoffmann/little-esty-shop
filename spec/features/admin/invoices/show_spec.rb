require 'rails_helper'

RSpec.describe 'admin invoice show page' do
  let!(:merchant) {FactoryBot.create(:merchant)}

  let!(:invoice_1) {FactoryBot.create(:invoice, status: "in progress")}
  let!(:invoice_2) {FactoryBot.create(:invoice, status: "in progress")}

  let!(:item_1) {FactoryBot.create(:item, merchant: merchant)}
  let!(:item_2) {FactoryBot.create(:item, merchant: merchant)}
  let!(:item_3) {FactoryBot.create(:item)}
  let!(:item_4) {FactoryBot.create(:item)}
  let!(:item_5) {FactoryBot.create(:item)}

  let!(:invoice_item_1) {FactoryBot.create(:invoice_item, invoice: invoice_1, item: item_1, unit_price: 300, quantity: 10, status: "pending")}
  let!(:invoice_item_2) {FactoryBot.create(:invoice_item, invoice: invoice_1, item: item_2, unit_price: 400, quantity: 5, status: "pending")}
  let!(:invoice_item_3) {FactoryBot.create(:invoice_item, invoice: invoice_1, item: item_3, unit_price: 100, status: "pending")}
  let!(:invoice_item_4) {FactoryBot.create(:invoice_item, invoice: invoice_2, item: item_2)}
  let!(:invoice_item_5) {FactoryBot.create(:invoice_item, invoice: invoice_2, item: item_3)}
  let!(:invoice_item_6) {FactoryBot.create(:invoice_item, invoice: invoice_2, item: item_4)}

  let!(:discount) {Discount.create(merchant: merchant, amount: 0.1, threshold: 10)}

  before(:each) do
    visit "/admin/invoices/#{invoice_1.id}"
  end

  it 'shows invoice id' do
    expect(page).to have_content(invoice_1.id)
  end

  it 'shows invoice status' do
    expect(page).to have_content(invoice_1.status)
  end

  it 'shows invoice created_at in correct format' do
    expect(page).to have_content(invoice_1.created_at.strftime("%A, %B %-d, %Y"))
  end

  it 'shows invoice customer first_name and last_name' do
    expect(page).to have_content(invoice_1.customer_name)
  end

  it 'shows each item ordered with info' do
    within("#invoice-item-0") do
      expect(page).to have_content(item_1.name)
      expect(page).to have_content(invoice_item_1.quantity)
      expect(page).to have_content("$3.00")
      expect(page).to have_content(invoice_item_1.status)
    end
    within("#invoice-item-1") do
      expect(page).to have_content(item_2.name)
      expect(page).to have_content(invoice_item_2.quantity)
      expect(page).to have_content("$4.00")
      expect(page).to have_content(invoice_item_2.status)
    end
    within("#invoice-item-2") do
      expect(page).to have_content(item_3.name)
      expect(page).to have_content(invoice_item_3.quantity)
      expect(page).to have_content("$1.00")
      expect(page).to have_content(invoice_item_3.status)
    end
  end

  it 'shows invoice total revenue' do
    expect(page).to have_content("$#{invoice_1.total_revenue.to_s.insert(-3, ".")}")
  end

  it 'can update invoice status' do
    expect(page).to have_select(:invoice_status, selected: 'in progress')
    select 'completed', from: :invoice_status
    click_on "Update Invoice Status"
    expect(current_path).to eq("/admin/invoices/#{invoice_1.id}")
    expect(page).to have_select(:invoice_status, selected: 'completed')
  end

  it 'shows invoice total after discounts applied' do
    save_and_open_page
    expect(page).to have_content("$#{invoice_1.total_with_discount}0")
  end

end
