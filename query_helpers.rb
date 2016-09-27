module QueryHelpers
  def self.included(base)
    base.extend ClassMethods
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

  def method_missing(method_name, *args)
    if self.class.methods.include?(method_name)
      self.class.send(method_name, *args)
    end
  end

  module ClassMethods
    def database
      @@db ||= SQLite3::Database.new("app.db");
    end

    def table_name
      @table_name
    end

    def properties
      @properties[:id] = { type: "integer", primary_key: true }
      @properties[:created_at] = { type: "varchar(10)" }
      @properties
    end

    def query_string(column_name, properties)
      query_builder = []
      increment = "PRIMARY KEY AUTOINCREMENT"
      properties[:type] = properties[:type].to_s
      properties[:nullable] = properties[:nullable] ? "NULL" : "NOT NULL"
      properties[:primary_key] = properties[:primary_key] ? "#{increment}" : ""
      query_builder << column_name.to_s + " " + properties.values.join(" ")
    end

    def table_properties
      constraints = []
      properties.each do |column_name, column_properties|
        constraints << query_string(column_name, column_properties)
      end

      constraints.join(", ")
    end

    def columns
      properties.keys
    end

    def map_row_to_object(row)
      return nil unless row
      model = new

      columns.each_with_index do |attribute, index|
        model.send("#{attribute}=", row[index])
      end

      model
    end
  end
end
