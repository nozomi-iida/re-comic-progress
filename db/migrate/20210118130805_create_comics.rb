class CreateComics < ActiveRecord::Migration[6.1]
  def change
    create_table :comics do |t|
      t.string :title
      t.integer :volume
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :comics, [:user_id, :created_at]
  end
end
