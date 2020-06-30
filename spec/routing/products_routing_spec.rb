require "rails_helper"

RSpec.describe ProductsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/").to route_to("products#index")
    end

    it "routes to #search" do
      expect(:get => "/search").to route_to("products#search")
    end
  end
end
