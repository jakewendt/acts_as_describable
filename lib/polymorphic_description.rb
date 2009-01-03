class PolymorphicDescription < ActiveRecord::Base
	belongs_to :describable, :polymorphic => true
end
