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

#get "/upgrade" do
#	authenticate!
#
#	if current_user.pro? || current_user.administrator?
#		flash[:error] = "Error: You are not eligible to upgrade."
#		redirect "/"
#	end
#
#	erb :pay
#end

#post "/charge" do
#
#  begin
#	  # Amount in cents
#	  @amount = params[price]
#	  @charge_am = @amount * 1.05
#
#	  customer = Stripe::Customer.create(
#	    :email => 'customer@example.com',
#	    :source  => params[:stripeToken]
#	  )

#	  charge = Stripe::Charge.create(
#	    :amount      => @charge_am,
#	    :description => 'Sinatra Charge',
#	    :currency    => 'usd',
#	    :customer    => customer.id
#	  )
	  
#	  @charge_me = @amount * 0.10
#	  payout = Stripe::payout.create (
#	  	:amount 	 => @charge_me,
#	  	:description => 'sinatra',
#	  	:currency	 => #OUR CARD ID
#	  )

#	  @charge_um = @amount * 0.95
#	  payout = Stripe::payout.create (
#	  	:amount 	 => @charge_um,
#	  	:description => 'sinatra',
#	  	:currency	 => #USER CARD ID
#	  )

#	  flash[:success] = "Success: You have upgraded to PRO."
#	  redirect "/"
#	rescue Stripe::CardError
#	  flash[:error] = "Error: Please try a new card."
#	  redirect "/"
#	end
#end

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

# If Reloaded Redirect to the Update page
get "/item/:id/update" do

	erb :"posts/item_update"
end

# Update item
post '/items/:id/update' do

  @item = Item.get(params[:id])
	@item.name = params[:name]
	@item.description = params[:description]
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
