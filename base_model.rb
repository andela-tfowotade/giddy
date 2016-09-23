module Giddy
  class GiddyRecord
    extend QueryHelpers

    def to_table(table_name)
      @table_name ||= table_name
    end

    def property(column_name, properties = {})
      @column_properties = []
      increment = "PRIMARY KEY AUTOINCREMENT"
      properties["type"] = properties["type"].to_s
      properties["nullable"] = properties["nullable"] ? "NULL" : "NOT NULL"
      properties[:primary_key] = properties[:primary_key] ? "#{increment}" : ""
      @column_properties << column_name.to_s + " " + properties.values.join(" ")
    end
    
    def create_table
      query_string = @column_properties.join(", ")
      query = "CREATE TABLE IF NOT EXISTS #{ table_name } (#{query_string })"
      @@db.execute query
    end
  end
end
