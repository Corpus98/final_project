require "sinatra"
require 'sinatra/flash'
require_relative "authentication.rb"


# items #
class Item
	include DataMapper::Resource

	property :id, Serial
  property :name, String
  property :description, String
	# property :location, String
  # property :image, String
  # property :owner, Class, User
	# property :available, Boolean,  :default => true
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

get "/upgradepro" do
	#!authenticate
	if
		erb :upgradepro
	else
		redirect "/"
	end
end

post "/search" do
	@items = Item.select{ |thing| thing.name.include? params[:search].to_s }
	#@items = Item.all { |thing| thing.name.include? params[:search].to_s }

	erb :search_results
end

# # search
# post "/search" do
# 	#authenticate!
# 	@query = Item.find(:name.like => "%#{params[:search]}%")
#
# 	erb :search_results
# end

# get "/search" do
#
# 	# searchResult = params[:search]
# 	@items = Item.get(:name.like => "%#{params[:search]}%")
#
# 	erb :search_results
# end






# display all items
get "/items" do

	@items = Item.all
	erb:item_page_all
end


# # delete item
# delete '/items/:id' do
#
#   Item.get(params[:id]).destroy
# end



# Item CRUD

get "/item/create_test" do
	erb:item_create
end

# create Item
post "/item/create" do

    i = Item.new
    i.name = params[:name]
    i.description = params[:description]
		# i.location = params[:location]
		# i.image = params[:image]
		# i.created_at = Time.now
    i.save
		redirect "/items"
		# redirect back
end

# //////////////////////////////////////////////

# update Item
get "/item/:id/update" do
	@item2 = Item.get(params[:id])
	erb:item_update
end

# update Profile
get "profile/:id/update" do
	"hello world"
	# erb:profile_update
end



post '/items/:id/update' do

  @update = Item.get(params[:id])
	@update.name = params[:name]
	@update.description = params[:description]
	@update.save
	redirect "/items"
end







# display individual items by id
get "/item/:id" do

	@item1 = Item.get(params[:id])
	erb :item_page_single
	# @item = Item.select{ |thing| thing.id.include? params[:id].to_i}
	# erb:item_page_single
end

# delete item
post '/item/:id' do

  Item.get(params[:id]).destroy
	redirect back
end
