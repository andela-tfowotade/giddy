class Todo < GiddyRecord
  to_table :todos
  property :title, type: :text
  property :body, type: :integer
  create_table
end
