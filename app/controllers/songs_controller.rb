class SongsController < ApplicationController
  def search
  	@query = params[:query]
  	return unless @query.present?

  	require 'net/http'
  	uri = URI.parse('https://api.spotify.com/v1/search?' + {q: @query, type: 'track'}.to_query)
  	json = Net::HTTP.get(uri)

  	# This lets me dump out a binary value
  	#render json: json

  	# Capture results as a hash
  	result_set = JSON.parse(json)
  	@results = result_set["tracks"]["items"]
  end
end
