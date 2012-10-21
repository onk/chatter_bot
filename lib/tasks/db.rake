#-*- coding: utf-8 -*-
require "active_record"
namespace :db do
  desc "migrate database."
  task :migrate do |t, args|
    config = YAML.load_file("config/database.yml")
    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Migrator.migrate(["db/migrate"])
  end

  desc "create database."
  task :create do |t, args|
    config = YAML.load_file("config/database.yml")
    ActiveRecord::Base.establish_connection(config.merge("database" => nil))
    ActiveRecord::Base.connection.create_database(config["database"], config)
  end

  desc "drop database."
  task :drop do |t, args|
    config = YAML.load_file("config/database.yml")
    ActiveRecord::Base.establish_connection(config)
    ActiveRecord::Base.connection.drop_database(config["database"])
  end

  namespace :schema do
    desc 'Create a db/schema.rb file that can be portably used against any DB supported by AR'
    task :dump do
      filename = "db/schema.rb"
      File.open(filename, "w:utf-8") do |file|
    config = YAML.load_file("config/database.yml")
        ActiveRecord::Base.establish_connection(config)
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end
end

