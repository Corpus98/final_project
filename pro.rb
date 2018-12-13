require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/pro.db")
end

class Pro
    include DataMapper::Resource
    property :id, Serial
    property :owner_id, Integer
    property :created_at, DateTime
    property :end_pro, DateTime :default => (DateTime + 2.628e+6)
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Pro.auto_upgrade!

