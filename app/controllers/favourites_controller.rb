class FavouritesController < ApplicationController
  before_action :set_favourite, only: [:show, :edit, :update, :destroy]

  # GET /favourites
  # GET /favourites.json
  def index
    @favourites = Favourite.all
  end

  # GET /favourites/1
  # GET /favourites/1.json
  def show
  end

  # GET /favourites/new
  def new
    @favourite = Favourite.new
  end

  # GET /favourites/1/edit
  def edit
  end

  # GET /favourites/search
  def search
    @query = params[:query]
    return unless @query.present?

    require 'net/http'
    uri = URI.parse('https://api.spotify.com/v1/search?' + {q: @query, type: 'track'}.to_query)
    json = Net::HTTP.get(uri)

    # This lets me dump out a binary value nicely
    #render json: json

    # Capture results as a hash
    result_set = JSON.parse(json)
    @results = result_set["tracks"]["items"]
  end

  def compare
    @first_person = params[:first_person]
    @second_person = params[:second_person]

    return unless (@first_person.present? and @second_person.present?)

    @all_favourites = Favourite.where(person: [@first_person, @second_person]).order(:spotify_id)
    @intersection = []

    @intersection_objects = @all_favourites.select("spotify_id, person").find_all { |f| @all_favourites.find{ |f2| f2.spotify_id == f.spotify_id && f2.person != f.person} }
    if !@intersection_objects.nil?
      @intersection_objects.each_entry{ |f| @intersection |= [f.spotify_id]  }
    end

  end

  # POST /favourites
  # POST /favourites.json
  def create
    @favourite = Favourite.new(favourite_params)

    respond_to do |format|
      if @favourite.save
        format.html { redirect_to @favourite, notice: 'Favourite was successfully created.' }
        format.json { render :show, status: :created, location: @favourite }
      else
        format.html { render :new }
        format.json { render json: @favourite.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /favourites/1
  # PATCH/PUT /favourites/1.json
  def update
    respond_to do |format|
      if @favourite.update(favourite_params)
        format.html { redirect_to @favourite, notice: 'Favourite was successfully updated.' }
        format.json { render :show, status: :ok, location: @favourite }
      else
        format.html { render :edit }
        format.json { render json: @favourite.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /favourites/1
  # DELETE /favourites/1.json
  def destroy
    @favourite.destroy
    respond_to do |format|
      format.html { redirect_to favourites_url, notice: 'Favourite was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_favourite
      @favourite = Favourite.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def favourite_params
      params.require(:favourite).permit(:person, :spotify_id, :name, :preview_url)
    end
end
