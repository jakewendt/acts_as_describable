require 'acts_as_describable'
require 'polymorphic_description'

#ActionView::Base.send(:include, ActsAsDescribableHelper)
ActiveRecord::Base.send( :include, Acts::Describable )
