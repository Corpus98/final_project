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
	property :cost_Day, Integer
	property :cost_Week, Integer
	property :available, Boolean,  :default => true

	# property :location, String
  # property :image, String
  # property :owner, Class, User

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
# get "/all_posts" do
# 	!authenticate
# 	@items = Item.all
# 	erb :"posts/all_posts"
# end

get "/become_pro" do
	#authenticate!
		erb :"payment/become_pro"

end

#get "/upgrade" do
	#authenticate!

	#erb :"payment/pay"
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
# get "/search" do
# 	@items = Item.all
# 	erb :"search/search_results"
# end


# Search Bar Item
post "/search" do

	@items = Item.select{ |thing| thing.name.include? params[:search].to_s }
	erb :"search/search_results"
end


# display all items
get "/items" do

	@items = Item.all
	erb :"posts/post_page_all"
end





################################################### Creation, Deletion, Update
# If Reloaded Redirect to the Create page
get "/post/create" do
	# erb:item_create
	erb :"posts/post_create"
end

# Create Item
post "/post/create" do

    i = Item.new
    i.name = params[:name]
    i.description = params[:description]
		i.cost_Day = params[:cost_per_day]
		i.cost_Week = params[:cost_per_week]
		# i.posters_ID = current_user
		# i.renters_ID = nil
		# i.available = false

    i.save
		redirect "/items"
		# redirect back
end

# //////////////////////////////////////////////

# If Reloaded Redirect to the Update page
get "/post/update/:id" do
	@update = Item.get(params[:id])
	erb :"posts/post_update"
end

post '/post/update/:id' do

  @update = Item.get(params[:id])
	@update.name = params[:name]
	@update.description = params[:description]
	@update.save
	redirect "/items"
end

# //////////////////////////////////////////////

# delete individual items by id
post '/post/:id' do

  Item.get(params[:id]).destroy
	redirect back
end


# //////////////////////////////////////////////

# display individual items by id
get "/item/:id" do

	@item1 = Item.get(params[:id])
	erb :"posts/post_page_single"

end

# //////////////////////////////////////////////


################################################### Updating User Profile
# If Reloaded Redirect to the User Update Page
get "/profile/update/:id" do

	@profile = current_user
	erb:profile_update
end

post '/profile/update/:id' do

  @profile = current_user
	@profile.first_name = params[:first_name]
	@profile.last_name = params[:last_name]
	@profile.save
	redirect "/dashboard"
	# redirect back
end
