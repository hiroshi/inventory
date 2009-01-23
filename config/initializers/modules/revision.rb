# = Revision - make revisioned copy at every INSERT/UPDATE
# WANING: monkey patching for SchemaStatements may not work other than PostgreSQL
# 
# == Usage example
# Add :revision => true option to create_table of which you want to be revisioned.
# 
#  create_table :pages, :revision => true do |t|
#    ...
#  end
# 
# It also creates page_revisions table inherits from pages with adding revision column.
# (Sorry, MySQL doesn't seem to support INHERITS option for CREATE TABLE).
# Also add the same option to drop_table.
# 
#  drop_table :pages, :revision => true
# 
# Then, include Revision::Model module in Page.
# 
#  class Page < ActiveRecord::Base
#    include Revision::Model
#  end
# 
# It appends after_save callback to insert page_revisions which values are same as saved page.
# 
# == Trouble shooting
# === PGError: ERROR:  duplicate key value violates unique constraint "index_XXX_on_id_and_revision"
# By default, with PostgreSQL 8's table inheritance, records of child tables appear in result of 
# query from parent the table. This behavior can alter by setting 'sql_inheritance' to 'off'.
# For more information:
# http://www.postgresql.org/docs/8.3/static/runtime-config-compatible.html#GUC-SQL-INHERITANCE

module Revision
  module Model
    def self.included(base)
      base.extend ClassMethods
      # define XyzRevision class
      remove_const("#{base.name}Revision") if const_defined?("#{base.name}Revision")
      klass = Class.new(base)
      klass.class_eval do
        set_table_name self.revision_table_name
      end
      const_set "#{base.name}Revision", klass

      base.class_eval do
        include InstanceMethods
        after_save :save_revision
        has_many :revisions, :class_name => "#{base.name}Revision", :foreign_key => "id", :readonly => true, :order => "revision DESC"
      end
    end

    module ClassMethods
      def revision_table_name
        self.table_name.singularize + "_revisions"
      end
    end

    module InstanceMethods
      def save_revision
        if self.changed?
          table = self.class.revision_table_name
          rev = self.connection.select_value("SELECT revision FROM #{table} WHERE id = #{self.id} ORDER BY revision DESC").to_i + 1
          cols = self.class.column_names.join(", ")
          self.connection.insert("INSERT INTO #{table} (#{cols}, revision) SELECT #{cols}, #{rev} FROM utilizations WHERE id = #{self.id}")
        end
      end
    end
  end
end

# TODO: to be separated module
ActiveRecord::ConnectionAdapters::SchemaStatements.module_eval do
  def create_table_with_revision(table_name, options = {}, &block)
    # create original table
    create_table_without_revision(table_name, options, &block)
    # create revisions table
    if options[:revision]
      rev_table = table_name.singularize + "_revisions"
      create_table_without_revision(rev_table, :options => "INHERITS (#{quote_table_name(table_name)})", :primary_key => false) do |t|
        t.integer :revision, :null => false
      end
      add_index rev_table, [:id, :revision], :unique => true
      # drop NOT NULL and PRIMARY KEY constraint of id
      change_column_default rev_table, :id, nil
      execute "alter table #{rev_table} drop CONSTRAINT #{rev_table}_pkey"
    end
  end
  alias_method_chain :create_table, :revision

  def drop_table_with_revision(table_name, options = {})
    # drop revisions table
    if options[:revision]
      rev_table = table_name.singularize + "_revisions"
      drop_table_without_revision(rev_table, options)
    end
    # drop original table
    drop_table_without_revision(table_name, options)
  end
  alias_method_chain :drop_table, :revision

end

ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.class_eval do
  def add_column_with_revision(table_name, column_name, type, options = {})
    # NOTE: to avoid "ERROR:  column must be added to child tables too"
    execute "SET sql_inheritance TO on"
    add_column_without_revision(table_name, column_name, type, options)
  rescue
    execute "SET sql_inheritance TO off"
  end
  alias_method_chain :add_column, :revision
end
