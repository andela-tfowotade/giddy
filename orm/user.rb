require_relative "base_model"

class User < GiddyRecord
  to_table :users
  property :name, type: :text
  property :email, type: :text
  create_table
end
# User.destroy_all
user = User.new(name: "temi", email: "temi@yahoo.com")
user.save
# puts user.name
# puts user.id
# tee = User.find(user.id)
# puts tee.name
puts user.destroy

# puts user.name
# puts user.destroy
# puts User.destroy(73)
# User.destroy(65)
# user.update(name: "themmy")
# puts user.id
# puts user.email
# puts user.name
