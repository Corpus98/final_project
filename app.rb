require "sinatra"
require 'sinatra/flash'
require_relative "authentication.rb"

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


get "/login" do	
	erb :login
end

get "/sign_up" do 
	erb :sign_up
end

get "/become_pro" do 
	#!authenticate
	if 
		erb :become_pro

	else
		redirect "/"
		
	end

end
get "/search" do 
	#authenticate!
	erb :search
end



get "/rent_out" do
	#authenticate!
	erb :rent_out
end

