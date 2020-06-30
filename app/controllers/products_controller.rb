class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.order(:title).page product_params[:page]
    @countries = Product.all.pluck(:country).uniq.sort
  end

  def search
    search = product_params[:search]

    @products = []
    unless search.blank? && params[:price].blank? && params[:country].blank?
      @products = Product.search(search, params).page(params[:page]).records
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def product_params
      params.permit(:page, :search, :country, :price => {})
    end
end
