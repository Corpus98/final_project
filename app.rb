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
# display individual items by id
get "/items/:id" do

	@items = Item.find(params[:id])
	erb:item_page_all
	# @item = Item.get(params[:id])
	# erb:item_page_single
end


# Item CRUD

get "/item/create" do
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

	erb:item_update
end



post '/items/:id/update' do

  @item = Item.get(params[:id])
	@item.name = params[:name]
	@item.description = params[:description]
	@item.save
	redirect "/items"
end





delete item
delete '/items/:id' do

  Item.get(params[:id]).destroy
end
