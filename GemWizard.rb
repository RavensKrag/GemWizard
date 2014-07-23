#!/usr/bin/env ruby

output_dir = "/home/ravenskrag/Code/SCRATCH_AREA/GEM_CREATION_TEST_DIR"

template_dir = "/home/ravenskrag/Code/Ruby/Gem template/"


Dir[File.join(template_dir, 'README.*')]



# ==================
# ===== config =====
# ==================

config = {
	name: "gem name",
	authors: ["Raven"],
	email: 'AvantFlux.Raven@gmail.com',
	homepage: 'https://github.com/RavensKrag',
	summary: 'TL;DR',
	description: <<-EOS
	many lines of text
	so many lines, of so much text
EOS
}

# ================== 
# ==================



template_project_name = 'automaton'

date = Time.now.strftime("%Y-%m-%d")







path_to_file = File.expand_path(File.dirname(__FILE__))
Dir.chdir path_to_file do
	require './monkey_patches/string'
end


def make_from_template(input_file, output_file, &block)
	# read in template
	str = File.readlines(input_file).join
	
	# mutate text
	str = block.call str
	
	# output new file
	File.open(output_file, 'w') do |f|
		f.puts str
	end
	
	return str
end







# README
	filename = 'README.md'
	path = File.join output_dir, filename
	File.open(path, 'w') do |f|
		
	end


# gemspec
	input_path = File.join template_dir, "#{template_project_name}.gemspec"
	output_path = File.join output_dir, "#{config[:name].dasherize}.gemspec"

	make_from_template input_path, output_path do |str|
		# replace names of the gem
		str.gsub! /#{template_project_name.dasherize}/, config[:name].dasherize
		str.gsub! /#{template_project_name.constantize}/, config[:name].constantize
		
		# replace parameters
		[:authors, :email, :homepage, :summary, :description].each do |param|
			str.gsub! /(s\.#{param}(?:.*?)= )(.*?)$/, '\1'+"#{config[param].inspect}"
		end
		
		
		
		str # pseudo return
	end


# rakefile
	input_path = File.join template_dir, 'Rakefile'
	output_path = File.join output_dir, 'Rakefile'

	make_from_template input_path, output_path do |str|
		# replace names of the gem
		str.gsub! /#{template_project_name.dasherize}/, config[:name].dasherize
		str.gsub! /#{template_project_name.constantize}/, config[:name].constantize
		
		
		str # pseudo return
	end
