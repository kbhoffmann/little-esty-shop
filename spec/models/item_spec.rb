require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:merchant) }
    it { should validate_numericality_of(:unit_price) }
    it { should define_enum_for(:status).with_values(disabled: 0,enabled: 1) }
  end

  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'instance methods' do
    let!(:merchant_1) {FactoryBot.create(:merchant)}
    let!(:merchant_2) {FactoryBot.create(:merchant)}

    let!(:item_1) {FactoryBot.create(:item, merchant: merchant_1, unit_price: 1000)}
    let!(:item_2) {FactoryBot.create(:item, merchant: merchant_1, unit_price: 800)}
    let!(:item_3) {FactoryBot.create(:item, merchant: merchant_1, unit_price: 500)}
    let!(:item_4) {FactoryBot.create(:item, merchant: merchant_1, unit_price: 100)}
    let!(:item_5) {FactoryBot.create(:item, merchant: merchant_1, unit_price: 200)}
    let!(:item_6) {FactoryBot.create(:item, merchant: merchant_1, unit_price: 300)}
    let!(:item_7) {FactoryBot.create(:item, merchant: merchant_1, unit_price: 300)}
    let!(:item_8) {FactoryBot.create(:item, merchant: merchant_1, unit_price: 500)}

    let!(:customer_1) {FactoryBot.create(:customer)}
    let!(:customer_2) {FactoryBot.create(:customer)}
    let!(:customer_3) {FactoryBot.create(:customer)}
    let!(:customer_4) {FactoryBot.create(:customer)}
    let!(:customer_5) {FactoryBot.create(:customer)}
    let!(:customer_6) {FactoryBot.create(:customer)}

    let!(:invoice_1) {FactoryBot.create(:invoice, customer: customer_1)}
    let!(:invoice_2) {FactoryBot.create(:invoice, customer: customer_1)}
    let!(:invoice_3) {FactoryBot.create(:invoice, customer: customer_2)}
    let!(:invoice_4) {FactoryBot.create(:invoice, customer: customer_2)}
    let!(:invoice_5) {FactoryBot.create(:invoice, customer: customer_3)}
    let!(:invoice_6) {FactoryBot.create(:invoice, customer: customer_4)}
    let!(:invoice_7) {FactoryBot.create(:invoice, customer: customer_5)}

    let!(:transaction_1) {FactoryBot.create(:transaction, invoice: invoice_1)}
    let!(:transaction_2) {FactoryBot.create(:transaction, invoice: invoice_2)}
    let!(:transaction_3) {FactoryBot.create(:transaction, invoice: invoice_3)}
    let!(:transaction_4) {FactoryBot.create(:transaction, invoice: invoice_4)}
    let!(:transaction_5) {FactoryBot.create(:transaction, invoice: invoice_5)}
    let!(:transaction_6) {FactoryBot.create(:transaction, invoice: invoice_6)}
    let!(:transaction_7) {FactoryBot.create(:transaction, invoice: invoice_7)}

    let!(:invoice_item_1) {FactoryBot.create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 9, unit_price: 1000, status: 2)}
    let!(:invoice_item_2) {FactoryBot.create(:invoice_item, invoice: invoice_2, item: item_1, quantity: 9, unit_price: 1000, status: 2)}
    let!(:invoice_item_3) {FactoryBot.create(:invoice_item, invoice: invoice_3, item: item_2, quantity: 2, unit_price: 800, status: 2)}
    let!(:invoice_item_4) {FactoryBot.create(:invoice_item, invoice: invoice_4, item: item_3, quantity: 3, unit_price: 500, status: 1)}
    let!(:invoice_item_5) {FactoryBot.create(:invoice_item, invoice: invoice_5, item: item_4, quantity: 1, unit_price: 100, status: 1)}
    let!(:invoice_item_6) {FactoryBot.create(:invoice_item, invoice: invoice_6, item: item_7, quantity: 1, unit_price: 300, status: 1)}
    let!(:invoice_item_7) {FactoryBot.create(:invoice_item, invoice: invoice_7, item: item_8, quantity: 1, unit_price: 500, status: 1)}
    let!(:invoice_item_8) {FactoryBot.create(:invoice_item, invoice: invoice_7, item: item_4, quantity: 1, unit_price: 100, status: 1)}


    describe '#best_day' do
      it 'shows the day in which an item generated the most revenue' do
        expect(item_1.best_day).to eq(invoice_2.created_at.to_date)
      end
    end
  end
end
