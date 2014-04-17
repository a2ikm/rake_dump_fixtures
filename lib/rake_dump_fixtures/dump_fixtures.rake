namespace :db do
  namespace :fixtures do
    desc <<-DESC
      Extract records to the tmp/fixtures/ directory in YAML format.
      Use FIXTURES=table_name[,table_name...] to specify table names to extract.
      Otherwise, all tables will be extracted.
    DESC
    task :dump => :environment do
      def fixture_entry(table_name, obj)
        res = []
        klass = table_name.singularize.camelize.constantize
        res << "#{table_name.singularize}#{obj['id']}:"
        klass.columns.each do |column|
          x = obj[column.name]
          if column.text?
            if x =~ /\r?\n/
              x = "|\n#{x}".gsub("\n", "\n    ")
            else
              x = "\"#{x}\""
            end
          end
          if column.type == :boolean
            x = ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(x)
          end
          res << "  #{column.name}: #{x}"
        end
        res.join("\n")
      end

      fixtures_dir = Rails.root.join("tmp/fixtures")
      sh "mkdir -p #{fixtures_dir}"

      sql = "SELECT * FROM %s ORDER BY id"
      skip_tables = ["schema_migrations"]
      ActiveRecord::Base.establish_connection

      if ENV['FIXTURES']
        table_names = ENV['FIXTURES'].split(/,/)
      else
        table_names = (ActiveRecord::Base.connection.tables - skip_tables)
      end

      table_names.each do |table_name|
        yml = fixtures_dir.join("#{table_name}.yml")
        $stderr.puts "Writing #{yml}"
        File.open(yml, "w") do |file|
          objects  = ActiveRecord::Base.connection.select_all(sql % table_name)
          objects.sort_by { |obj| obj["id"].to_i }.each do |obj|
            file.write  fixture_entry(table_name, obj) + "\n\n"
          end
        end
      end
    end
  end
end
