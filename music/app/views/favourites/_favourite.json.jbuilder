json.extract! favourite, :id, :person, :spotify_id, :name, :preview_url, :created_at, :updated_at
json.url favourite_url(favourite, format: :json)
