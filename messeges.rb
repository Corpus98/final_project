require 'data_mapper' # metagem, requires common plugins too.

# need install dm-sqlite-adapter
# if on heroku, use Postgres database
# if not use sqlite3 database I gave you
if ENV['DATABASE_URL']
  DataMapper::setup(:default, ENV['DATABASE_URL'] || 'postgres://localhost/mydb')
else
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/db/mess.db")
end

class Messege
    include DataMapper::Resource
    property :id, Serial
    property :to_ID, Integer
    property :from_ID, Integer
    property :statment, string

    def from_who
        if from_ID == nil
            return "Grandma"
        else 
            @P = User.first(e.id == self.from_ID)
            return @P.first_name + " " + @P.last_name
    end 

    def to_who
        @P = User.first(e.id == self.to_ID)
        return @P.first_name + " " + @P.last_name
end

# Perform basic sanity checks and initialize all relationships
# Call this when you've defined all your models
DataMapper.finalize

# automatically create the post table
Messege.auto_upgrade!

