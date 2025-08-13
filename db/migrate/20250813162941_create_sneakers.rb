class CreateSneakers < ActiveRecord::Migration[8.0]
  def change
    create_table :sneakers do |t|
      t.string :brand
      t.string :model
      t.string :colorway
      t.string :size
      t.string :sku
      t.integer :price_cents
      t.string :currency
      t.text :description
      t.integer :condition
      t.integer :stock
      t.boolean :published
      t.string :slug

      t.timestamps
    end
    add_index :sneakers, :slug
  end
end
