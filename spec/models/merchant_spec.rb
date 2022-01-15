require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "relationships" do
    it { should have_many :items }
  end

  describe 'class methods' do
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

    describe '::top_merchants' do
      it 'returns the top five merchants by revenue' do
        merchants = [merchant_7, merchant_6, merchant_5, merchant_4, merchant_3]

        expect(Merchant.top_merchants).to eq(merchants)
      end
    end

    describe '::filter_merchant_status'
      it 'returns merchants based on status' do
        expect(Merchant.filter_merchant_status(0)).to include(merchant_1)
        expect(Merchant.filter_merchant_status(1)).to include(merchant_2)
      end
    end
  end

  describe 'instance methods' do
    let!(:merchant_1) {FactoryBot.create(:merchant)}
    let!(:merchant_2) {FactoryBot.create(:merchant)}

    let!(:item_1) {FactoryBot.create(:item, merchant: merchant_1, status: "disabled")}
    let!(:item_2) {FactoryBot.create(:item, merchant: merchant_1, status: "enabled")}
    let!(:item_3) {FactoryBot.create(:item, merchant: merchant_1, status: "disabled")}
    let!(:item_4) {FactoryBot.create(:item, merchant: merchant_1, status: "enabled")}
    let!(:item_5) {FactoryBot.create(:item, merchant: merchant_1)}
    let!(:item_6) {FactoryBot.create(:item, merchant: merchant_2)}

    let!(:customer_1) {FactoryBot.create(:customer)}
    let!(:customer_2) {FactoryBot.create(:customer)}
    let!(:customer_3) {FactoryBot.create(:customer)}
    let!(:customer_4) {FactoryBot.create(:customer)}
    let!(:customer_5) {FactoryBot.create(:customer)}
    let!(:customer_6) {FactoryBot.create(:customer)}

    let!(:invoice_1) {FactoryBot.create(:invoice, customer: customer_1, status: "in progress")}
    let!(:invoice_2) {FactoryBot.create(:invoice, customer: customer_2, status: "in progress")}
    let!(:invoice_3) {FactoryBot.create(:invoice, customer: customer_3, status: "in progress")}
    let!(:invoice_4) {FactoryBot.create(:invoice, customer: customer_4, status: "in progress")}
    let!(:invoice_5) {FactoryBot.create(:invoice, customer: customer_5, status: "in progress")}

    let!(:transaction_1) {FactoryBot.create(:transaction, invoice: invoice_1, result: "success")}
    let!(:transaction_2) {FactoryBot.create(:transaction, invoice: invoice_1, result: "success")}
    let!(:transaction_3) {FactoryBot.create(:transaction, invoice: invoice_1, result: "success")}

    let!(:transaction_4) {FactoryBot.create(:transaction, invoice: invoice_2, result: "success")}
    let!(:transaction_5) {FactoryBot.create(:transaction, invoice: invoice_2, result: "success")}
    let!(:transaction_6) {FactoryBot.create(:transaction, invoice: invoice_2, result: "success")}
    let!(:transaction_7) {FactoryBot.create(:transaction, invoice: invoice_2, result: "success")}
    let!(:transaction_8) {FactoryBot.create(:transaction, invoice: invoice_2, result: "success")}

    let!(:transaction_9) {FactoryBot.create(:transaction, invoice: invoice_3, result: "success")}

    let!(:transaction_10) {FactoryBot.create(:transaction, invoice: invoice_4, result: "success")}
    let!(:transaction_11) {FactoryBot.create(:transaction, invoice: invoice_4, result: "success")}
    let!(:transaction_12) {FactoryBot.create(:transaction, invoice: invoice_4, result: "success")}
    let!(:transaction_13) {FactoryBot.create(:transaction, invoice: invoice_4, result: "success")}

    let!(:transaction_14) {FactoryBot.create(:transaction, invoice: invoice_5, result: "success")}
    let!(:transaction_15) {FactoryBot.create(:transaction, invoice: invoice_5, result: "success")}
    let!(:transaction_16) {FactoryBot.create(:transaction, invoice: invoice_5, result: "failed")}

    let!(:invoice_item_1) {FactoryBot.create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1, unit_price: 100, status: "pending")}
    let!(:invoice_item_2) {FactoryBot.create(:invoice_item, invoice: invoice_2, item: item_2, quantity: 2, unit_price: 100, status: "pending")}
    let!(:invoice_item_3) {FactoryBot.create(:invoice_item, invoice: invoice_3, item: item_3, quantity: 3, unit_price: 100, status: "packaged")}
    let!(:invoice_item_4) {FactoryBot.create(:invoice_item, invoice: invoice_4, item: item_4, quantity: 4, unit_price: 100, status: "packaged")}
    let!(:invoice_item_5) {FactoryBot.create(:invoice_item, invoice: invoice_5, item: item_5, quantity: 5, unit_price: 100, status: "packaged")}

    describe '#top_customers' do
      it 'returns the top 5 customers for a merchant' do
        customers = [customer_2, customer_4, customer_1, customer_5, customer_3]
        expect(merchant_1.top_customers).to eq(customers)
      end
    end

    describe '#ready_items' do
      it 'returns the items which have not yet shipped' do
        items = [item_3, item_4, item_5]
        expect(merchant_1.ready_items).to eq(items)
      end
    end

    describe '#filter_item_status' do
      it 'filters items by status' do
        expect(merchant_1.filter_item_status(0)).to include(item_1, item_3)
        expect(merchant_1.filter_item_status(1)).to include(item_2, item_4)
      end
    end

    describe '#top_items' do
      it 'returns the top 5 items by revenue for a merchant' do
        top_5_items = []
        expect(merchant_1.top_items).to eq(top_5_items)
      end
    end
  end
