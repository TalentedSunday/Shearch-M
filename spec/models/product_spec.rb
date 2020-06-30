require 'rails_helper'

# Note the `elasticsearch: true` tag in this block:
RSpec.describe Product, elasticsearch: true, type: :model do
  describe '#search' do
    before(:each) do
      Product.create!(
        :title =>"Roman Holiday",
        :description => "A 1953 American romantic comedy films ...",
        :tags => "Tags",
        :country => "Country",
        :price => 2.5
      )

      Product.__elasticsearch__.refresh_index!
    end
    it "should index title" do
      expect(Product.search("Holiday", {}).records.length).to eq(1)
    end
    it "should index description" do
      expect(Product.search("comedy", {}).records.length).to eq(1)
    end
    it "should not index tags" do
      expect(Product.search("Roman_holiday.jpg", {}).records.length).to eq(0)
    end
    it "should return product within price filter range" do
      expect(Product.search("", {:price => { lte: 3, gte: 2}}).records.length).to eq(1)
    end
    it "should not return product outside price filter range" do
      expect(Product.search("", {:price => { lte: 5, gte: 3}}).records.length).to eq(0)
    end

    it "should return product from a particular country" do
      expect(Product.search("", {:country => 'Country'}).records.length).to eq(1)
    end

    it "should not return product not from country" do
      expect(Product.search("", {:country => 'USA'}).records.length).to eq(0)
    end
  end
end
