require "sinatra"
require 'sinatra/flash'
require_relative "authentication.rb"
# require_relative "item.rb"
# require_relative "transaction.rb"


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

################################################### Creation, Deletion, Update
# //////////// POST CREATE
# DISPLAYS ALL ITEMSS
get "/items" do
	@items = Item.all
	erb :"posts/posts"
end

get "/posts/my_posts" do
	@item = Item.select{ |thing| thing.owner_id == current_user }
	erb :"posts/posts"
end 

# If Reloaded Redirect to the Create page
get "/item/create" do
	authenticate!
	erb :"posts/post_create"
end

# Create Item
post "/item/create" do
    i = Item.new
	i.name = params[:name]
	i.description = params[:descripiton]
	i.cost_Day = params[:cost_per_day]
	i.cost_Week = params[:cost_per_week]

	i.owner_id = current_user.id
	i.available = true

	i.save

	@cur_user = User.find { current_user }
	@cur_user.rented_out = i.id

	redirect "/dashboard"
end

# //////////// POST UPDATE
# If Reloaded Redirect to the Update page
# Update the thing
get "/post/update/:id" do
	if current_user.id == Item.get(params[:id]).owner_id ################## MAKE SURE ONLY THE OWNER CAN DO THIS
		@item =  Item.get(params[:id])
		erb :"/posts/posts_update"
	else 
		redirect "/"
	end
end

# Update the thing
post "/post/update/:id" do
    @item = Item.get(params[:id])
	@item.name = params[:name]
	@item.description = params[:description]
	@item.save
	redirect "/items"
end

# //////////// POST DELETION
# delete individual items by id
post '/remove/:id' do
	if current_user.id == Item.get(params[:id]).owner_id ################## MAKE SURE ONLY THE OWNER CAN DO THIS
 		Item.get(params[:id]).destroy
		redirect "/dashboard"
	else
		redirect "/"
	end
end

# ////////////////////////////////////////////// PROFILE UPDATE
# If Reloaded Redirect to the User Update Page
get "/profile/update/:id" do
	if current_user == User.get(params[:id]) ################## MAKE SURE ONLY THE OWNER CAN DO THIS
		@profile = current_user
		erb :"user/profile_update"
	else
		redirect "/"
	end
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
	authenticate!
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

post "/rent_out/:id" do
	authenticate!
	@t = Transaction.new
	@t.renters_id = current_user.id
	@t.item_id = params[:id]
	@t.owner_id = Item.get(params[:id]).owner_id
	@t.renter_confirmation = 1
	@t.save

	if Transaction.find { |e| e == @t  }
	# notify owner
	@t.destroy

	@L = Messege.new
	@L.to_id = @t.owner_id
	@L.statment = "Currently Waiting for the Owner to Confirm Transaction"
	@L.save

	redirect "/"
	else

	# notify owner
	@L = Messege.new
	@L.to_id = @t.owner_id
	@L.statment = "Someone want what your renting"
	@L.save

	redirect back
	end
end

post "/rent_confirm/:id" do
	authenticate!
	@t = Transaction.select { |e| e.item_id == :id }
	if @t.owner_confirmation == 0 && current_user.id == @t.owner_id # owner Comfirms the request agreeing to the rental
		@t.owner_confirmation = 1
		@t.save

		@i = Item.select {|e| e.id == @t.item_id}

		# notify the renter
		@M = Messege.new
		@M.to_id = @t.renters_id
		@M.statment = "The owner has agreed to your request, Confirm you gain possesion of the the item"
		@M.save

		redirect "/dashboard"

	elsif @t.renter_confirmation == 1 && current_user.id  == @t.renters_id # The renter is confirming his possetion of the item	
		@t.rent_out 

		charging = Item.find { |e| @t.item_id }.cost_Day
		our_tax = charging * 0.05
		# charge a fee to the renter

		### MAKE CHARGE
		#IF SUCCESFUL CONTINUE ELSE TERMINATE TRANSACTON AND NOTIFY BOTH PARTIES

		@M = Messege.new
		@M.to_id = @t.renters_id
		charging
		@M.statment = "You have been charged (charging + our_tax)"
		@M.save

		# pay a fee to the owner
		### MAKE PAYMENT
		#IF SUCCESFUL CONTINUE ELSE TERMINATE TRANSACTON AND NOTIFY BOTH PARTIES && RETURN PAYMENT TO THE RENTER
		@M = Messege.new
		@M.to_id = @t.owner_id
		@M.statment = "You have been payed (charging - our_tax)"
		@M.save

		@t.renter_confirmation = 2
		@t.owner_confirmation = 2

		#flash success
		redirect "/dashboard"

	elsif @t.owner_confirmation == 2 && current_user.id == @t.owner_id #owner comfirms return of item
	 	@t.destroy
	 	# Notify both parties
		@M = Messege.new
		@M.to_id = @t.renters_id
		# charging
		@M.statment = "Thank-you for renting with us"
		@M.save

		@M = Messege.new
		@M.to_id = @t.owner_id
		@M.statment = "Thank-you for renting with us"
		@M.save

		redirect "/dashboard"
	
	else

		redirect "/"	
	end
end

get "/mess&alerts" do
	@messeges = Messege.select{ |mess| mess.to_id == current_user.id }
	erb :"messages/messeges"
end