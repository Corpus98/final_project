require "sinatra"
require 'sinatra/flash'
require_relative "authentication.rb"


# items #
class Item
	include DataMapper::Resource

	property :id, Serial
	property :posters_ID, Integer
	property :renters_ID, Integer
  	property :name, String
  	property :description, String
  	property :cost_Day, Integer
  	property :cost_Week, Integer
  	property :available, Boolean


 	def rent_out
    	# make it unavailable
    	Item.available = false

    	# 
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
	# authenticate!
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

################################################### Membership/ Payment
get "/all_posts" do 
	!authenticate
	@items = Item.all
	erb :"posts/all_posts"
end

get "/become_pro" do 
	authenticate!
	if 
		erb :"payment/become_pro"
	else
		redirect "/"
	end
end

################################################### Search BAR
# If Reloaded Return All possible Results
get "/search" do
	@items = Item.all
	erb :"search/search_results"
end

# Search Bar Item
post "/search" do
	@items = Item.select{ |thing| thing.name.include? params[:search].to_s }

	erb :"search/search_results"
end

# display all items
get "/items" do

	@items = Item.all
	erb :"posts/all_posts"
end

# display individual items by id
get "/items/:id" do

	@items = Item.find(params[:id])
	erb :"posts/all_posts"
	# @item = Item.get(params[:id])
	# erb:item_page_single
end


################################################### Creation, Deleation, Update 
# If Reloaded Redirect to the Create page
get "/item/create" do
	erb :"posts/post_create"
	
end

# Create Item
post "/item/create" do
	### has_attached_file :image, style
    @item = Item.new
	@item.name = params[:title]
	@item.description = params[:descripiton]
	@item.cost_Day = params[:cost_per_day]
	@item.cost_Week = params[:cost_per_week]

	@item.posters_ID = current_user
	@item.renters_ID = nil
	@item.available = false

	@item.save

	# redirect "/items/:id"
	redirect "/dashboard"
end


# If Reloaded Redirect to the Update page
get "/items/:id/update" do
	erb :"posts/item_update"
end

# Update item
post '/items/:id/update' do

    @item = Item.get(params[:id])
	@item.name = params[:name]
	@item.description = params[:description]
	@item.cost_Day = params[:cost_per_day]
	@item.cost_Week = params[:cost_per_week]

	@item.available = true
	@item.save

	redirect "/items"
end

# Delete item
delete '/items/:id' do
 # if Item.get(params[:id].nil?
    Item.get(params[:id]).destroy
    # redirect "/"
 	# Flash Success
 # else
    # redirect "/"
 	# Flash Failure
end
