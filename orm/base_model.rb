require "sqlite3"
require_relative "query_helpers"

class GiddyRecord
  include QueryHelpers

  def initialize(attributes = {})
    attributes.each { |column_name, value| send("#{column_name}=", value) }
  end

  def self.to_table(table_name)
    @table_name ||= table_name
  end

  def self.property(column_name, column_attributes)
    @properties ||= {}
    @properties[column_name] = column_attributes
  end

  def self.create_table
    query = "CREATE TABLE IF NOT EXISTS #{table_name} (#{table_properties})"
    execute query

    columns.each { |column| attr_accessor column }
  end

  def save
    @created_at = Time.now.to_s
    query = "INSERT INTO #{table_name} (#{columns.join(', ')}) VALUES (#{new_record_placeholders})"
    execute(query, new_record_values)
    set_id
    self
  end

  alias save! save

  def update(options = {})
    update_placeholders = []
    values = []

    options.each do |column_name, value|
      send("#{column_name}=", value)
      update_placeholders << "#{column_name}= ?"
      values << value
    end

    query = "UPDATE #{table_name} SET #{update_placeholders.join(', ')} WHERE id=#{id}"
    execute(query, values.join(", "))
  end

  def destroy
    self.class.destroy(id)
  end

  def self.create(attributes)
    new(attributes).save
  end

  def self.destroy(id)
    query = "DELETE FROM #{table_name} WHERE id=#{id}"
    execute query
    true
  end

  def self.destroy_all
    query = "DELETE FROM #{table_name}"
    execute(query)
    true
  end

  def self.all
    query = "SELECT * FROM #{table_name}"
    rows = execute(query)
    rows.map { |result| map_row_to_object(result) }
  end

  def self.find(id)
    query = "SELECT * FROM #{table_name} WHERE id=#{id} LIMIT 1"
    row = execute(query)
    map_row_to_object(row[0])
  end

  def self.first
    query = "SELECT * FROM #{table_name} ORDER BY id LIMIT 1"
    row = execute(query)
    map_row_to_object(row[0])
  end

  def self.last
    query = "SELECT * FROM #{table_name} ORDER BY id DESC LIMIT 1"
    row = execute(query)
    map_row_to_object(row[0])
  end
end
