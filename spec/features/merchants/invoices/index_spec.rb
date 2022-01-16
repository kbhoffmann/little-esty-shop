require 'rails_helper'

RSpec.describe 'merchant invoice index page' do

  let!(:merchant_1) {FactoryBot.create(:merchant)}

  let!(:item_1) {FactoryBot.create(:item, merchant: merchant_1)}
  let!(:item_2) {FactoryBot.create(:item, merchant: merchant_1)}
  let!(:item_3) {FactoryBot.create(:item, merchant: merchant_1)}

  let!(:invoice_1) {FactoryBot.create(:invoice)}

  let!(:invoice_item_1) {FactoryBot.create(:invoice_item, invoice: invoice_1, item: item_1)}
  let!(:invoice_item_2) {FactoryBot.create(:invoice_item, item: item_2)}
  let!(:invoice_item_3) {FactoryBot.create(:invoice_item, item: item_3)}

  before(:each) do
    visit merchant_invoices_path(merchant_1)
  end

  it 'shows merchant invoice ids that include a merchants item' do
    expect(page).to have_content(invoice_item_1.invoice_id)
    expect(page).to have_content(invoice_item_2.invoice_id)
    expect(page).to have_content(invoice_item_3.invoice_id)
  end

  it 'links to invoice show page' do
    click_link "#{invoice_1.id}"

    expect(current_path).to eq(merchant_invoice_path(merchant_1, invoice_1))
  end
end
