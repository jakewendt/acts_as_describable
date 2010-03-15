require 'test/unit'
require 'rubygems'
require 'active_record'
#require 'active_support'
require 'active_support/test_case'

#$:.unshift "#{File.dirname(__FILE__)}/../lib"
#require 'acts_as_describable'
#require 'polymorphic_description'
#ActiveRecord::Base.class_eval { include Acts::Describable }

require File.dirname(__FILE__) + '/../init'


ActiveRecord::Base.establish_connection(
	:adapter => "sqlite3", 
	:database => ":memory:")

def setup_db
	ActiveRecord::Schema.define(:version => 1) do
		create_table :polymorphic_descriptions do |t|
			t.text :body
			t.references :describable, :polymorphic => true
			t.timestamps
		end
		create_table :listings do |t|
			t.string :name
			t.timestamps
		end
		create_table :stores do |t|
			t.string :name
			t.timestamps
		end
	end
end

def teardown_db
	ActiveRecord::Base.connection.tables.each do |table|
		ActiveRecord::Base.connection.drop_table(table)
	end
end

class Store < ActiveRecord::Base
	acts_as_describable
end

class Listing < ActiveRecord::Base
	acts_as_describable :required => true
end
