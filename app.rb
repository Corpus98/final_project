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
	authenticate!
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
	#authenticate!
	# @items = Item.all(:name.like => "%#{params[:search]}%")
	#
	# erb :search_results
end

get "/search" do
	@items = Item.all(:name.like => "%#{params[:search]}%")

	erb :search_results
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
    i.save

		return "successfully added item"
  else
    return "missing information"
end

# update Item
post "/item_update" do

end


# delete item
# '/item/:id'
delete '/item' do
	Item.get(params[:id]).destroy

end
