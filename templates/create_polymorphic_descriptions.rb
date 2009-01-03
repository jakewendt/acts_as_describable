class CreatePolymorphicDescriptions < ActiveRecord::Migration
	def self.up
		create_table :polymorphic_descriptions do |t|
			t.references :describable, :polymorphic => true
			t.text       :body
			t.timestamps
		end
	end

	def self.down
		drop_table :polymorphic_descriptions
	end
end
