class CreateFavourites < ActiveRecord::Migration[5.1]
  def change
    create_table :favourites do |t|
      t.string :person
      t.string :spotify_id
      t.string :name
      t.string :preview_url

      t.timestamps
    end
  end
end
