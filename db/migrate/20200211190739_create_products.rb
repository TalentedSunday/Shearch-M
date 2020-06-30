class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.string :description
      t.string :tags
      t.string :country
      t.float :price

      t.timestamps
    end
  end
end
