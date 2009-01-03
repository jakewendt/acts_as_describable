# ActsAsDescribable
module Upillar
	module Acts #:nodoc:
		module Describable #:nodoc:
			def self.included(base)
				base.extend(ClassMethods)
			end

			module ClassMethods
				def acts_as_describable(options = {})
					configuration = { :required => false }
					configuration.update(options) if options.is_a?(Hash)

					# include InstanceMethods
					# extend SingletonMethods
					include Upillar::Acts::Describable::InstanceMethods
					extend  Upillar::Acts::Describable::SingletonMethods

					has_one	:polymorphic_description, :as => :describable, :dependent => :destroy

					if self.accessible_attributes
						attr_accessible :description
					end

					after_save :save_description

					if configuration[:required]
#						validates_presence_of_description
						validates_each :description do |record,attr,value|
							record.errors.add(nil, "Description cannot be blank") if value.blank?
						end
					end
				end
			end

			#	class methods like a find or something
			module SingletonMethods
			end

			module InstanceMethods

				def description=(desc)
					if self.polymorphic_description
						self.polymorphic_description.body = desc
					else
						self.polymorphic_description = PolymorphicDescription.new({:body => desc})
					end
				end

				def description
					return ( self.polymorphic_description ) ? self.polymorphic_description.body : '' ;
				end

			protected

				def save_description
					if self.polymorphic_description
						self.polymorphic_description.save
					end
				end

			end 
		end
	end
end
