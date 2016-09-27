require "sqlite3"

class GiddyRecord
  def initialize(attributes = {})
    attributes.each { |column_name, value| send("#{column_name}=", value) }
  end

  def self.database
    @@db ||= SQLite3::Database.new("app.db");
  end

  def self.to_table(table_name)
    @table_name ||= table_name
  end
  
  def self.table_name
    @table_name
  end

  def self.property(column_name, column_attributes)
    @properties ||= {}
    @properties[column_name] = column_attributes
  end

  def self.properties
    @properties[:id] = { type: "integer", primary_key: true }
    @properties[:created_at] = { type: "varchar(10)" }
    @properties
  end

  def self.query_string(column_name, properties)
    query_builder = []
    increment = "PRIMARY KEY AUTOINCREMENT"
    properties[:type] = properties[:type].to_s
    properties[:nullable] = properties[:nullable] ? "NULL" : "NOT NULL"
    properties[:primary_key] = properties[:primary_key] ? "#{increment}" : ""
    query_builder << column_name.to_s + " " + properties.values.join(" ")
  end

  def self.table_properties
    constraints = []
    properties.each do |column_name, column_properties|
      constraints << query_string(column_name, column_properties)
    end

    constraints.join(", ")
  end
  
  def self.create_table
    attr_accessor :id, :created_at
    query = "CREATE TABLE IF NOT EXISTS #{table_name} (#{table_properties})"
    database.execute query

    columns.each { |col| attr_accessor col }
  end

  def self.columns
    properties.keys
  end

  def new_record_placeholders
    (['?'] * properties.size).join(", ")
  end

  def new_record_values
    values = columns.map { |column| send(column) }
  end

  def set_id
    id = database.execute "SELECT last_insert_rowid()"
    self.id = id[0][0]
  end

  def save
    @created_at = Time.now.to_s
    query = "INSERT INTO #{table_name} (#{columns.join(", ")}) VALUES (#{new_record_placeholders})"
    database.execute(query, new_record_values)
    set_id
  end

  def update(options = {})
    update_placeholders = []
    values = []

    options.each do |column_name, value| 
      send("#{column_name}=", value)
      update_placeholders << "#{column_name}= ?"
      values << value
    end

    query = "UPDATE #{table_name} SET #{update_placeholders.join(", ")} WHERE id=#{id}"
    database.execute(query, values.join(", "))
  end

  def method_missing(method_name, *args)
    if self.class.methods.include?(method_name)
      self.class.send(method_name, *args)
    end
  end
end
