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









class String
	# (the following assume that the input string is space delineated)
	
	# convert to camelCase
	def camelize
		parts = self.split
		
		# capitalize all words except the first one
		list = self.split.collect do |i|
			if i == parts.first
				i
			else
				i.capitalize
			end
		end
		
		return list.join('')
	end
	
	# convert to snake_case
	def underscore
		return self.split.join('_')
	end
	
	# convert to ConstantCase
	def constantize
		return self.split.collect{|i| i.capitalize}.join('')
	end
	
	# separate pieces with dashes
	# (name taken from Rails)
	def dasherize
		return self.split.join('-')
	end
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
