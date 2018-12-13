require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/item.db")
end

# items #
class Item
    include DataMapper::Resource

    property :id, Serial
    property :name, String
    property :description, String

    property :owner_ID, Integer

    property :cost_Day, Integer
    property :cost_Week, Integer
    property :available, Boolean,  :default => true
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Item.auto_upgrade!