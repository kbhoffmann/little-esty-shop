require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should belong_to :customer }
  end

  describe "validations" do
    it { should validate_presence_of(:customer) }
    it { should validate_presence_of(:status) }
  end

  describe 'instance methods' do
    let!(:customer) {FactoryBot.create(:customer, first_name: "Cookie", last_name: "Monster")}
    let!(:invoice_1) {FactoryBot.create(:invoice, customer: customer, created_at: Date.today)}
    let!(:invoice_2) {FactoryBot.create(:invoice)}
    let!(:item_1) {FactoryBot.create(:item, status: "enabled")}
    let!(:item_2) {FactoryBot.create(:item)}
    let!(:invoice_item_1) {FactoryBot.create(:invoice_item, invoice: invoice_1, item: item_1, status: "pending", quantity: 5, unit_price: 1000)}
    let!(:invoice_item_2) {FactoryBot.create(:invoice_item, invoice: invoice_1, item: item_2, quantity: 10, unit_price: 2000)}

    describe '#pretty_created_at' do
      it 'formats created_at datetime' do
        expect(invoice_1.pretty_created_at).to eq(Date.today.strftime("%A, %B %-d, %Y"))
      end
    end

    describe '#customer_name' do
      it 'outputs customer full name' do
        expect(invoice_1.customer_name).to eq("Cookie Monster")
      end
    end

    describe '#items_info' do
      it 'shows invoice items with order info' do
        first = invoice_1.items_info.first
        expect(first.name).to eq(item_1.name)
        expect(first.quantity).to eq(invoice_item_1.quantity)
        expect(first.status).to eq(invoice_item_1.status)
        expect(first.unit_price).to eq(invoice_item_1.unit_price)
      end
    end

    describe '#total_revenue' do
      it 'calculates total revenue for invoice' do
        expect(invoice_1.total_revenue).to eq(25000)
      end
    end
  end
end
