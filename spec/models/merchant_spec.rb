require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:status) }
  end

  describe "relationships" do
    it { should have_many :items }
    it { should have_many :discounts }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
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
    before :each do
       @merchant_1 = Merchant.create!(name: 'Hair Care')
       @merchant_2 = Merchant.create!(name: 'Jewelry')

       @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant_1.id, status: 1)
       @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant_1.id)
       @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant_1.id, status: 1)
       @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant_1.id)
       @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant_1.id)
       @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant_1.id)

       @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant_2.id)
       @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant_2.id)

       @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
       @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
       @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
       @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
       @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
       @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

       @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 1)
       @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 1)
       @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 1)
       @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 1)
       @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 1)
       @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 1)
       @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)
       @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 2)

       @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 9, unit_price: 10, status: 0, created_at: "2012-03-27 14:54:09")
       @ii_2 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0, created_at: "2012-03-29 14:54:09")
       @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 2, unit_price: 8, status: 2, created_at: "2012-03-28 14:54:09")
       @ii_4 = InvoiceItem.create!(invoice_id: @invoice_4.id, item_id: @item_3.id, quantity: 3, unit_price: 5, status: 1, created_at: "2012-03-30 14:54:09")
       @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-01 14:54:09")
       @ii_7 = InvoiceItem.create!(invoice_id: @invoice_6.id, item_id: @item_7.id, quantity: 1, unit_price: 3, status: 1, created_at: "2012-04-02 14:54:09")
       @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 1, unit_price: 5, status: 1, created_at: "2012-04-03 14:54:09")
       @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-04 14:54:09")
       @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_4.id, quantity: 1, unit_price: 1, status: 1, created_at: "2012-04-05 14:54:09")

       @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
       @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
       @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
       @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
       @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
       @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
       @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
       @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)
     end

    describe '#top_customers' do
      it 'returns the top 5 customers for a merchant' do
        customers = [@customer_1, @customer_6, @customer_2, @customer_3, @customer_4]
        expect(@merchant_1.top_customers).to eq(customers)
      end
    end

    describe '#ready_items' do
      it 'returns the items which have not yet shipped' do
        expect(@merchant_1.ready_items[0]).to eq(@item_3)
        expect(@merchant_1.ready_items[1]).to eq(@item_4)
        expect(@merchant_1.ready_items[2]).to eq(@item_7)
        expect(@merchant_1.ready_items[3]).to eq(@item_4)
        expect(@merchant_1.ready_items[4]).to eq(@item_8)
        expect(@merchant_1.ready_items[5]).to eq(@item_4)
      end
    end

    describe '#filter_item_status' do
      it 'filters items by status' do
        expect(@merchant_1.filter_item_status(1)).to include(@item_1, @item_3)
        expect(@merchant_1.filter_item_status(0)).to include(@item_2, @item_4)
      end
    end

    describe '#top_items' do
      it 'returns the top 5 items by revenue for a merchant' do
        top_5_items = [@item_1, @item_2, @item_3, @item_8, @item_4]
        expect(@merchant_1.top_items).to eq(top_5_items)
      end
    end

    describe '#best_day' do
      it 'returns day with highest revenue' do
        expect(@merchant_1.best_day).to eq(@invoice_8.created_at)
      end
    end
  end
