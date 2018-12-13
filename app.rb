require "sinatra"
require 'sinatra/flash'
require_relative "authentication.rb"


# items #
class Item
	include DataMapper::Resource

	property :id, Serial
 	property :name, String
  	property :description, String

	property :posters_ID, Integer
	property :renters_ID, Integer
	#property :renters_ID, Integer

	property :cost_Day, Integer
	property :cost_Week, Integer
	property :available, Boolean,  :default => true

 	def rent_out
    	# make it unavailable
    	Item.available = false
  	end


end

Item.auto_upgrade!

#the following urls are included in authentication.rb
# GET /login
# GET /logout
# GET /sign_up

# authenticate! will make sure that the user is signed in, if they are not they will be redirected to the login page
# if the user is signed in, current_user will refer to the signed in user object.
# if they are not signed in, current_user will be nil

get "/" do
	erb :index
end

get "/dashboard" do
	authenticate!
	# Shwo all option to edit your information
	# Show my rented out item if any and my options with that item
	erb :dashboard
end

# authentication views
get "/login" do
	erb :login
end

get "invalid_login" do
	erb :invalid_login
end

get "/sign_up" do
	erb :signup
end

get "successful_signup" do
	erb :successful_signup
end

################################################### Creation, Deletion, Update
# //////////// POST CREATE
# DISPLAYS ALL ITEMSS
get "/items" do
	@items = Item.all

	erb :"posts/posts"
end

# If Reloaded Redirect to the Create page
get "/item/create" do
	erb :"posts/posts_create"
end

# Create Item
post "/item/create" do
	### has_attached_file :image, style

    i = Item.new
	i.name = params [:name]
	i.description = params[:description]
	i.cost_Day = params[:cost_per_day]
	i.cost_Week = params[:cost_per_week]

	i.posters_ID = current_user
	i.renters_ID = nil
	

	i.save
	@cur_user = User.find { current_user }
	@cur_user.rented_out = i.id

	redirect "/dashboard"
end

# display individual items by id
# get "/item/:id" do
# 	@item = Item.get(params[:id])
# 	erb :"posts/posts"
# end

# //////////// POST UPDATE
# If Reloaded Redirect to the Update page
get "/item/update/:id" do
	@update = Item.get(params[:id])
	erb :"posts/posts_update"
end

# Update the thing
post "/item/update/:id" do
    @update = Item.get(params[:id])
	@update.name = params[:name]
	@update.description = params[:description]
	@update.save
	redirect "/items"
end

# //////////// POST DELETION
# delete individual items by id
post '/remove/:id' do
 	Item.get(params[:id]).destroy
	redirect back
end

# ////////////////////////////////////////////// PROFILE UPDATE
# If Reloaded Redirect to the User Update Page
get "/profile/update/:id" do

	@profile = current_user
	erb :"user/profile_update"
end

post "/profile/update/:id" do

  @profile = current_user
	@profile.first_name = params[:first_name]
	@profile.last_name = params[:last_name]
	@profile.save
	redirect "/dashboard"
end

# //////////////////////////////////////////////
get "/become_pro" do
	erb :"payment/become_pro"
end

post "/become_pro" do
	current_user.pro = true
	current_user.save
	redirect "/"
end

################################################### POSTS && VIEWS
# Search Bar Item
post "/search" do
	@item = Item.select{ |thing| thing.name.include? params[:search].to_s }
	erb :"posts/posts"
end