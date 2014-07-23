#!/usr/bin/env ruby
require 'fileutils'


path_to_file = File.expand_path(File.dirname(__FILE__))
Dir.chdir path_to_file do
	require './monkey_patches/string'
end




module GemWizard
	class Wizard


def initialize(output_dir, config={})
	# Set default parameters of config
	config[:date] ||= Time.now.strftime("%Y-%m-%d")
	
	# Set other variables
	@template_project_name = 'example'
	
	path_to_file = File.expand_path(File.dirname(__FILE__))
	@template_dir = File.join path_to_file, 'template'
	
	
	@output_dir = output_dir
	@config = config
end

def run
	readme
	gemspec
	rakefile
	
	
	directory_structure
		bin
		ext
		lib
		test
end



private

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




def readme
	filename = 'README.md'
	path = File.join @output_dir, filename
	File.open(path, 'w') do |f|
		
	end
end

def gemspec
	input_path = File.join @template_dir, "#{@template_project_name}.gemspec"
	output_path = File.join @output_dir, "#{@config[:name].dasherize}.gemspec"

	make_from_template input_path, output_path do |str|
		# replace names of the gem
		str.gsub! /#{@template_project_name.dasherize}/, @config[:name].dasherize
		str.gsub! /#{@template_project_name.constantize}/, @config[:name].constantize
		
		# replace parameters
		[:date, :authors, :email, :homepage, :summary, :description].each do |param|
			str.gsub! /(s\.#{param}(?:.*?)= )(.*?)$/, '\1'+"#{@config[param].inspect}"
		end
		
		
		
		str # pseudo return
	end
end

def rakefile
	input_path = File.join @template_dir, 'Rakefile'
	output_path = File.join @output_dir, 'Rakefile'

	make_from_template input_path, output_path do |str|
		# replace names of the gem
		str.gsub! /#{@template_project_name.dasherize}/, @config[:name].dasherize
		str.gsub! /#{@template_project_name.constantize}/, @config[:name].constantize
		
		
		str # pseudo return
	end
end



def directory_structure
	Dir.chdir @output_dir do
		%w[bin ext lib test].each do |dirname|
			FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
		end
	end
end

def bin
	# NOTHING
end

def ext
	# create directory structure
	Dir.chdir File.join @output_dir, 'ext' do
		dirname = @config[:name].dasherize
		FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
	end
	
	# copy over files
	input_name  = @template_project_name.dasherize
	output_name = @config[:name].dasherize
	
	
	# (get template file names)
	path = File.join '.', 'ext', '**', '*' # './DIR/**/*' grabs everything under DIR recursively
	templates = nil
	Dir.chdir @template_dir do
		# need relative paths, not absolute ones, so you need to change directory
		templates = Dir[path]
		templates.reject!{|i| File.directory? i }
	end
	
	# (generate pairs of templates, and their source destinations)
	pairs = templates.zip templates.collect{|i| i.gsub /#{input_name}/, output_name}
	
	
	# (traverse list of pairs, copying over things as necessary)
	pairs.each do |input, output|
		full_input_path = File.expand_path input, @template_dir
		full_output_path = File.expand_path output, @output_dir
		
		make_from_template full_input_path, full_output_path do |str|
			# replace names of the gem
			str.gsub! /Init_#{@template_project_name.underscore}/, "Init_#{@config[:name].underscore}"
			
			str.gsub! /#{@template_project_name.dasherize}/, @config[:name].dasherize
			str.gsub! /#{@template_project_name.constantize}/, @config[:name].constantize
			
			
			# str.gsub! /#{@template_project_name.underscore}/, "#{@config[:name].underscore}"
			
			
			str # pseudo return
		end
	end
end

def lib
	Dir.chdir File.join @output_dir, 'lib' do
		# create directory structure
		dirname = @config[:name].dasherize
		FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
		
		
		# Create necessary files
		name = @config[:name].dasherize
		File.open "./#{name}.rb", 'w' do |f|
			f.puts "# require '#{name}/#{name}' # Load c extension files"
		end
	end
end

def test
	full_input_path  = File.join @template_dir, 'test', 'test.rb'
	full_output_path = File.join @output_dir,   'test', 'test.rb'
	
	make_from_template full_input_path, full_output_path do |str|
		# replace names of the gem
		str.gsub! /#{@template_project_name.constantize}Test/, "#{@config[:name].constantize}Test"
		
		
		str.gsub! /#{@template_project_name.dasherize}/, @config[:name].dasherize
		
		
		str # pseudo return
	end
end



end
end







output_dir = "/home/ravenskrag/Code/SCRATCH_AREA/GEM_CREATION_TEST_DIR"


config = {
	name: "example",
	date: Time.now.strftime("%Y-%m-%d"),
	authors: ["NAME"],
	email: 'address@provider.com',
	homepage: 'https://test.com/index.html',
	summary: 'short summary',
	description: <<-EOS
	full description of the library goes in this section
	many lines of text
	so many lines, of so much text
EOS
}

# ================== 
# ==================

wizard = GemWizard::Wizard.new output_dir, config
wizard.run