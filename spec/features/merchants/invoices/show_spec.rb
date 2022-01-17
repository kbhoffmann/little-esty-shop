require 'rails_helper'

RSpec.describe 'merchant invoice show page' do
  let!(:merchant_1) {FactoryBot.create(:merchant)}
  let!(:merchant_2) {FactoryBot.create(:merchant)}

  let!(:item_1) {FactoryBot.create(:item, merchant: merchant_1)}
  let!(:item_2) {FactoryBot.create(:item, merchant: merchant_1)}
  let!(:item_3) {FactoryBot.create(:item, merchant: merchant_1)}
  let!(:item_4) {FactoryBot.create(:item, merchant: merchant_2)}

  let!(:invoice_1) {FactoryBot.create(:invoice, status: 0)}
  let!(:invoice_2) {FactoryBot.create(:invoice, status: 1)}

  let!(:transaction_1) {FactoryBot.create(:transaction, invoice: invoice_1, credit_card_expiration_date: Date.today, result: 0)}

  let!(:invoice_item_1) {FactoryBot.create(:invoice_item, quantity: 100, unit_price: 100, item: item_1, invoice: invoice_1, status: 0)}
  let!(:invoice_item_2) {FactoryBot.create(:invoice_item, quantity: 50, unit_price: 50, item: item_2, invoice: invoice_1, status: 1)}

  let!(:invoice_item_3) {FactoryBot.create(:invoice_item, quantity: 300, unit_price: 300, item: item_3, invoice: invoice_2, status: 2)}
  let!(:invoice_item_4) {FactoryBot.create(:invoice_item, item: item_4)}

  let!(:discount) {Discount.create(merchant: merchant_1, amount: 10, threshold: 100)}


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

  it 'wont apply discounts unless threshold is met (ex 1)' do
    discount_a = Discount.create!(amount: 20, threshold: 10, merchant: merchant_1)
    invoice_a = FactoryBot.create(:invoice)
    ii_1 = FactoryBot.create(:invoice_item, invoice: invoice_a, item: item_1, unit_price: 100, quantity: 5)
    ii_2 = FactoryBot.create(:invoice_item, invoice: invoice_a, item: item_2, unit_price: 100, quantity: 5)

    expect(ii_1.applicable_discount).to eq(nil)
    expect(ii_2.applicable_discount).to eq(nil)
    expect(invoice_a.total_revenue).to eq(invoice_a.total_with_discount)
  end

  it 'only applies to items that meet quantity threshold (ex 2)' do
    discount_a = Discount.create!(amount: 20, threshold: 10, merchant: merchant_1)
    invoice_a = FactoryBot.create(:invoice)
    ii_1 = FactoryBot.create(:invoice_item, invoice: invoice_a, item: item_1, unit_price: 100, quantity: 10)
    ii_2 = FactoryBot.create(:invoice_item, invoice: invoice_a, item: item_2, unit_price: 100, quantity: 5)

    expect(ii_1.applicable_discount).to eq(discount_a)
    expect(ii_2.applicable_discount).to eq(nil)
    expect(invoice_a.total_revenue).to eq(15)
    expect(invoice_a.total_with_discount).to eq(13)
  end

  it 'applies the most appropriate discount to each applicable item (ex 3)' do
    discount_a = Discount.create!(amount: 20, threshold: 10, merchant: merchant_1)
    discount_b = Discount.create!(amount: 30, threshold: 15, merchant: merchant_1)
    invoice_a = FactoryBot.create(:invoice)
    ii_1 = FactoryBot.create(:invoice_item, invoice: invoice_a, item: item_1, unit_price: 100, quantity: 12)
    ii_2 = FactoryBot.create(:invoice_item, invoice: invoice_a, item: item_2, unit_price: 100, quantity: 15)

    expect(ii_1.applicable_discount).to eq(discount_a)
    expect(ii_2.applicable_discount).to eq(discount_b)
    expect(invoice_a.total_revenue).to eq(27)
    expect(invoice_a.total_with_discount).to eq(20.1)
  end

  it 'applies highest discount amount per qualifying item (ex 4)' do
    discount_a = Discount.create!(amount: 20, threshold: 10, merchant: merchant_1)
    discount_b = Discount.create!(amount: 15, threshold: 15, merchant: merchant_1)
    invoice_a = FactoryBot.create(:invoice)
    ii_1 = FactoryBot.create(:invoice_item, invoice: invoice_a, item: item_1, unit_price: 100, quantity: 12)
    ii_2 = FactoryBot.create(:invoice_item, invoice: invoice_a, item: item_2, unit_price: 100, quantity: 15)

    expect(ii_1.applicable_discount).to eq(discount_a)
    expect(ii_2.applicable_discount).to eq(discount_a)
    expect(invoice_a.total_revenue).to eq(27)
    expect(invoice_a.total_with_discount).to eq(21.6)
  end

  it 'can only apply discounts to items belonging to discount merchant (ex 5)' do
    discount_a = Discount.create!(amount: 20, threshold: 10, merchant: merchant_1)
    discount_b = Discount.create!(amount: 30, threshold: 15, merchant: merchant_1)
    invoice_a = FactoryBot.create(:invoice)
    ii_1 = FactoryBot.create(:invoice_item, invoice: invoice_a, item: item_1, unit_price: 100, quantity: 12)
    ii_2 = FactoryBot.create(:invoice_item, invoice: invoice_a, item: item_2, unit_price: 100, quantity: 15)
    ii_3 = FactoryBot.create(:invoice_item, invoice: invoice_a, item: item_4, unit_price: 100, quantity: 15)

    expect(ii_1.applicable_discount).to eq(discount_a)
    expect(ii_2.applicable_discount).to eq(discount_b)
    expect(ii_3.applicable_discount).to eq(nil)
    expect(invoice_a.total_revenue).to eq(42)
    expect(invoice_a.total_with_discount).to eq(35.1)
  end

  it 'shows total after discounts' do
    expect(page).to have_content("Total after discounts: $115.00")
  end

  it 'links to discount applied' do
    click_link("#{discount.id}")
    expect(current_path).to eq(merchant_discount_path(merchant_1, discount))
  end
end
