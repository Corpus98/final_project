require "sinatra"
require 'sinatra/flash'
require_relative "authentication.rb"
# require 'stripe'

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
	  	:amount 	 =>@charge_me,
	  	:description =>'sinatra',
	  	:currency	 => #OUR CARD ID
	  )

	  @charge_um = @amount * 0.95
	  payout = Stripe::payout.create (
	  	:amount 	 =>@charge_um,
	  	:description =>'sinatra',
	  	:currency	 => #USER CARD ID
	  )




	  flash[:success] = "Success: You have upgraded to PRO."
	  redirect "/"
	rescue Stripe::CardError
	  flash[:error] = "Error: Please try a new card."
	  redirect "/"
	end
end
