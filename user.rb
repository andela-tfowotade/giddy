require_relative "base_model"

class User < GiddyRecord
  to_table :users
  property :name, type: :text
  property :email, type: :text
  create_table
end

user = User.new(name: "temi", email: "temi@yahoo.com")
user.save
user.update(name: "themmy")
puts user.id
puts user.email
puts user.name
# puts user.name
