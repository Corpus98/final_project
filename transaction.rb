require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/trans.db")
end

class Transaction
    include DataMapper::Resource

    property :owner_ID, Integer
    property :renters_ID, Integer
    property :item_ID, Integer

    property :created_at, DateTime, :default => nil
    property :owner_confirmation, Integer, :default => 0
    property :renter_confirmation, Integer, :default => 0

    def rent_out
    	
    end
end 

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Transaction.auto_upgrade!