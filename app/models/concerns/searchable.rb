module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    after_commit do
      __elasticsearch__.index_document
    end

    after_commit on: [:destroy] do
      __elasticsearch__.delete_document
    end

    def as_indexed_json(_options = {})
      as_json(only: %i[title tags description price country])
    end

    settings index: { number_of_shards: 1 } do
      mapping dynamic: false do
        indexes :title, type: :text, analyzer: :autocomplete
        indexes :tags, type: :text, analyzer: :english
        indexes :description, type: :text, analyzer: :english
        indexes :country, type: :text
        indexes :price, type: :float
      end
    end

    def self.search(query, filters)
      set_filters = lambda do |context_type, filter|
        @search_definition[:query][:bool][context_type] |= [filter]
      end

      @search_definition = {
        size: 25, query: { bool: { must: [], should: [], filter: [] } }
      }

      if query.blank? && filters[:price].andand[:lte].blank? &&
         filters[:price].andand[:gte].blank? &&
         filters[:country].blank?
        set_filters.call(:must, match_all: {})
      end

      if query.present?
        set_filters.call(:should, match: { title: { query: query, boost: 3 } })
        set_filters.call(:should, match: { tags: { query: query, boost: 2 } })
        set_filters.call(
          :should,
          match: { description: { query: query, boost: 1 } }
        )
      end

      if filters[:price].andand[:lte].present? ||
         filters[:price].andand[:gte].present?
        gte = filters[:price][:gte].to_f unless filters[:price][:gte].blank?
        lte = filters[:price][:lte].to_f unless filters[:price][:lte].blank?

        set_filters.call(:filter, range: { price: { gte: gte, lte: lte } })
      end

      if filters[:country].present?
        set_filters.call(:filter, match: { country: filters[:country] })
      end
      
      __elasticsearch__.search(@search_definition)
    end
  end

  class_methods do
    def settings_attributes
      {
        index: {
          analysis: {
            analyzer: {
              autocomplete: {
                type: :custom,
                tokenizer: :standard,
                filter: %i[lowercase autocomplete]
              }
            },
            filter: {
              autocomplete: { type: :edge_ngram, min_gram: 2, max_gram: 25 }
            }
          }
        }
      }
    end
  end
end