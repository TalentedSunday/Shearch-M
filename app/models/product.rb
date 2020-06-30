require 'elasticsearch/model'

class Product < ApplicationRecord
  include Searchable

  paginates_per 25
end
