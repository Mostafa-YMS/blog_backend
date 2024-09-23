class CreateTags < ActiveRecord::Migration[7.1]
  def change
    create_table :tags do |t|
      t.string :text
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
