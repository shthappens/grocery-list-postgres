require "sinatra"
require "pry"
require "pg"
require_relative "./models/grocery"
system "psql grocery_list_development < schema.sql"
system "psql grocery_list_development < data.sql"

set :bind, '0.0.0.0'  # bind to all interfaces

configure :development do
  set :db_config, { dbname: "grocery_list_development" }
end

configure :test do
  set :db_config, { dbname: "grocery_list_test" }
end

def db_connection
  begin
    connection = PG.connect(Sinatra::Application.db_config)
    yield(connection)
  ensure
    connection.close
  end
end

FILENAME = "grocery_list.txt"

def grocery_info
  @grocery_id = params[:id]
  @groceries_info = db_connection { |conn| conn.exec(
  "SELECT groceries.id, groceries.name, comments.body
  FROM groceries
  LEFT JOIN comments ON comments.grocery_id=groceries.id
  WHERE groceries.id='#{@grocery_id}'"
  ) }.to_a
end

get "/" do
  redirect "/groceries"
end

get "/groceries" do
  @groceries = db_connection do |conn|
    conn.exec("SELECT * FROM groceries")
  end
  erb :groceries
end

post "/groceries" do
  @new_grocery_errors = []
  @new_grocery = Grocery.new(params{})
  @new_grocery.save
  redirect "/groceries"
end

get "/groceries/:id" do
  grocery_info
  erb :"groceries/show"
end
