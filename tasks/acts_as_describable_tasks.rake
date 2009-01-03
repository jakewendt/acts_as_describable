namespace :acts_as_describable do

	namespace :import do

		desc "Import plugin migration file(s) into db/migrate/"
		task :migrations => :environment do
			require 'rails_generator'
			require 'rails_generator/scripts/generate'
			migrations_before = Dir.glob('db/migrate/*rb')
			#	it would be great if this returned the filename
			# but it returns
			# [[:migration_template, ["migration.rb", "db/migrate", {:assigns=>{:attributes=>[]}}], nil]] 
			# which seems totally pointless
			Rails::Generator::Scripts::Generate.new.run(['migration', 'CreatePolymorphicDescriptions'])
			migrations_after = Dir.glob('db/migrate/*rb')
			#	**should** only be one file difference
			new_migration = (migrations_after - migrations_before).first
			File::open(new_migration,"w") do |f| 
				f.puts IO.read(File.dirname(__FILE__) + "/../templates/create_polymorphic_descriptions.rb")
			end
		end

	end

end
