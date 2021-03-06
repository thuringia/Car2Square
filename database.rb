require 'sinatra'
require 'sinatra/sequel'

Sequel::Model.plugin :timestamps

# Establish the database connection; or, omit this and use the DATABASE_URL
# environment variable as the connection string:
set :database, ENV['DATABASE_URL']

"
# At this point, you can access the Sequel Database object using the
# 'database' object:
puts \"the foos table doesn't exist\" if !database.table_exists?('foos')

# define database migrations. pending migrations are run at startup and
# are guaranteed to run exactly once per database."

migration "drop old users" do
  database.drop_table(:users)
end

migration "create new users table" do
  database.create_table :users do
    primary_key :id
    text        :f_id
    text        :username
    text        :f_token
    text        :c_token
    timestamp   :created, :null => false
  end
end

# you can also alter tables
migration "move to sequel model" do
  database.drop_table(:users)
end

migration "add fs_users table" do
  database.create_table :fs_users do
    primary_key :id
    text        :f_id
    text        :name
    text        :f_token
    text        :c_token
  end
end
"
# models just work ...
class Foo < Sequel::Model
  many_to_one :bar
end

# see:
Foo.filter(:baz => 42).each { |foo| puts(foo.bar.name) }

# access the database within the context of an HTTP request
get '/foos/:id' do
  @foo = database[:foos].filter(:id => params[:id]).first
  erb :foos
end

# or, using the model
delete '/foos/:id' do
  @foo = Foo[params[:id]]
  @foo.delete
end
"