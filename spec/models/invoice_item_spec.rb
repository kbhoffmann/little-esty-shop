require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of(:item) }
    it { should validate_presence_of(:invoice) }
    it { should validate_presence_of(:status)}
    it { should validate_numericality_of(:quantity) }
    it { should validate_numericality_of(:unit_price) }
  end

  describe "relationships" do
    it { should belong_to :item }
    it { should belong_to :invoice }
    it { should have_one(:merchant).through(:item) }
    it { should have_many(:discounts).through(:merchant) }
  end

  describe "class methods" do
    before(:each) do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @c1 = Customer.create!(first_name: 'Bilbo', last_name: 'Baggins')
      @c2 = Customer.create!(first_name: 'Frodo', last_name: 'Baggins')
      @c3 = Customer.create!(first_name: 'Samwise', last_name: 'Gamgee')
      @c4 = Customer.create!(first_name: 'Aragorn', last_name: 'Elessar')
      @c5 = Customer.create!(first_name: 'Arwen', last_name: 'Undomiel')
      @c6 = Customer.create!(first_name: 'Legolas', last_name: 'Greenleaf')
      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8, merchant_id: @m1.id)
      @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m1.id)
      @i1 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i3 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i4 = Invoice.create!(customer_id: @c3.id, status: 2)
      @i5 = Invoice.create!(customer_id: @c4.id, status: 2)
      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
      @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 1)
    end
    it 'incomplete_invoices' do
      expect(InvoiceItem.incomplete_invoices).to eq([@i1, @i3])
    end
  end

  describe 'instance methods' do
    let!(:merchant) {FactoryBot.create(:merchant)}

    let!(:discount_1) {Discount.create(merchant: merchant, amount: 10, threshold: 10)}
    let!(:discount_2) {Discount.create(merchant: merchant, amount: 20, threshold: 20)}

    let!(:item) {FactoryBot.create(:item, merchant: merchant)}
    let!(:invoice) {FactoryBot.create(:invoice)}
    let!(:ii) {FactoryBot.create(:invoice_item, invoice: invoice, item: item, unit_price: 100, quantity: 15)}

    describe 'applicable_discount' do
      it 'calculates amount of discount that applies' do
        expect(ii.applicable_discount).to eq(discount_1)
        expect(ii.applicable_discount).to_not eq(discount_2)
      end
    end

    describe 'order_total' do
      it 'returns total of each invoice_item' do
        expect(ii.order_total).to eq(15)
      end
    end

    describe 'discounted_total' do
      it 'returns total for invoice_item with applicable discounts' do
        expect(ii.discounted_total).to eq(13.5)
      end
    end
  end

end
