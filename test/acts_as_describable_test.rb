require 'test/unit'
require 'rubygems'
require 'active_record'
#require File.dirname(__FILE__) + '/../init'

$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'acts_as_describable'
require 'polymorphic_description'
ActiveRecord::Base.class_eval { include Upillar::Acts::Describable }

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :dbfile => ":memory:")

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


class ActsAsDescribableTest < Test::Unit::TestCase

	def setup
		setup_db
	end

	def teardown
		teardown_db
	end

	def test_create_polymorphic_description
		assert_difference('PolymorphicDescription.count',1,"1 PolymorphicDescription should've been created") {
			@polymorphic_description = create_polymorphic_description
		}
		assert_nil @polymorphic_description.describable
		assert_difference('PolymorphicDescription.count',-1,"-1 PolymorphicDescription should've been created") {
			@polymorphic_description = PolymorphicDescription.first.destroy
		}
	end

	def test_should_create_describable_without_unrequired_polymorphic_description
		assert_difference('PolymorphicDescription.count',0,"0 PolymorphicDescription should've been created") {
		assert_difference('Store.count',      1,"1 Store should've been created") {
			@store = create_store
		} }
		assert_not_nil @store.description
		assert @store.description == ""
		assert_nil @store.polymorphic_description
		assert !@store.new_record?
	end

	def test_should_create_describable_with_required_polymorphic_description
		assert_difference('PolymorphicDescription.count',1,"1 PolymorphicDescriptions should've been created") {
		assert_difference('Listing.count',    1,"1 Listings should've been created") {
			@listing = create_listing
		} }
		assert_not_nil @listing.description
		assert_not_nil @listing.polymorphic_description
		assert_not_nil @listing.polymorphic_description.body
		assert !@listing.new_record?
		assert !@listing.polymorphic_description.new_record?
		assert_difference('PolymorphicDescription.count',-1,"-1 PolymorphicDescription should've been created") {
			@polymorphic_description = @listing.polymorphic_description.destroy
		}
	end

	def test_should_not_create_describable_without_required_polymorphic_description
		assert_difference('PolymorphicDescription.count',0,"0 PolymorphicDescriptions should've been created") {
		assert_difference('Listing.count',    0,"0 Listings should've been created") {
			@listing = create_listing(:description => nil)
		} }
		assert @listing.errors
		assert_nil @listing.description
		assert_nil @listing.polymorphic_description.body
		assert @listing.new_record?
		assert @listing.polymorphic_description.new_record?
	end


	def create_polymorphic_description(options={})
		record = PolymorphicDescription.new( {
			:body => "My Listing"
		}.merge(options) )
		record.save
		record
	end

	def create_listing(options={})
		record = Listing.new( {
			:name => "My Listing",
			:description => "My Listing"
		}.merge(options) )
		record.save
		record
	end

	def create_store(options={})
		record = Store.new( {
			:name => "My Store"
		}.merge(options) )
		record.save
		record
	end

end
