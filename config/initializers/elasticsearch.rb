Elasticsearch::Model.client = Elasticsearch::Client.new log: true

Kaminari::Hooks.init if defined?(Kaminari::Hooks)
Elasticsearch::Model::Response::Response.include Elasticsearch::Model::Response::Pagination::Kaminari
