Rails.application.routes.draw do
  resources :favourites do
  	collection do
  		get 'search'
  		get 'compare'
  	end
  end

  get 'songs/search'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
