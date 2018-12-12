get "/upgrade" do
	authenticate!

	if current_user.pro? || current_user.administrator?
		flash[:error] = "Error: You are not eligible to upgrade."
		redirect "/"
	end

	erb :pay
end

post "/charge" do

  begin
	  # Amount in cents
	  @amount = params[price]
	  @charge_am = @amount * 1.05

	  customer = Stripe::Customer.create(
	    :email => 'customer@example.com',
	    :source  => params[:stripeToken]
	  )

	  charge = Stripe::Charge.create(
	    :amount      => @charge_am,
	    :description => 'Sinatra Charge',
	    :currency    => 'usd',
	    :customer    => customer.id
	  )

	  @charge_me = @amount * 0.10
	  payout = Stripe::payout.create (
	  	:amount 	 => @charge_me,
	  	:description => 'sinatra',
	  	:currency	 => #OUR CARD ID
	  )

	  @charge_um = @amount * 0.95
	  payout = Stripe::payout.create (
	  	:amount 	 => @charge_um,
	  	:description => 'sinatra',
	  	:currency	 => #USER CARD ID
	  )




	  flash[:success] = "Success: You have upgraded to PRO."
	  redirect "/"
	rescue Stripe::CardError
	  flash[:error] = "Error: Please try a new card."
	  redirect "/"
	end
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
