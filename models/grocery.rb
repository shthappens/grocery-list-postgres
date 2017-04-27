require 'pry'

class Grocery

  attr_reader :name, :errors, :comment

  def initialize(params = {})
    @name = params["name"]
    # @comment = params["body"]
    @errors = []
    @input_array = [@name]
    @valid = true
  end

  def self.all
    grocery_array = []
    @groceries = db_connection { |conn| conn.exec(
      "SELECT groceries.id, groceries.name, comments.body, comments.id
      FROM groceries
      LEFT JOIN comments ON comments.grocery_id=groceries.id"
      ) }
    @groceries.each do |groceries|
      grocery_array << Grocery.new(grocery)
    end
    grocery_array
  end

  def incomplete_entry?
    if @input_array.any? { |input| input.empty? }
      @errors << "Please fill out form"
      @valid = false
    end
    @valid
  end

  def duplicate_entry?
    db_groceries = db_connection { |conn| conn.exec_params("SELECT name FROM groceries") }
    db_groceries.each do |grocery|
      if !grocery.empty? && grocery.has_value?(@name)
        @errors << "Grocery already submitted"
        @valid = false
      end
    end
    @valid
  end

  def valid?
    incomplete_entry?
    duplicate_entry?
    if @errors.empty?
      @valid = true
    else
      @valid = false
    end
    @valid
  end

  def save
    if valid?
      db_connection do |conn|
        conn.exec_params("INSERT INTO groceries (name)
        VALUES ($1);",
        [@name])
      end
      @valid = true
    end
    @valid
  end
end
