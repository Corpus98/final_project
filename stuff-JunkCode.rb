
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












	### has_attached_file :image, #style {large: "600x600>", medium: "300x300>", thumb: "150x150>"}
	### validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
	# property :location, String
    # property :image, String
    # property :owner, Class, User
	# property :available, Boolean,  :default => true

 	### def up
    	### add_attachment :Item, :image
  	### end

  	### def down
    	### remove_attachment :Item, :image
  	### end

  	
    ### @filename = params[:file][:filename]
 	### file = params[:file][:tempfile]
	### i.location = params[:location]
	### i.image = params[:image]
	### i.created_at = Time.now