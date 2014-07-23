require File.expand_path("../lib/example/version", __FILE__)

ENABLE_C_EXTENSION = false

Gem::Specification.new do |s|
	s.name        = "example"
	s.version     = Example::VERSION
	s.date        = "2014-07-23"
	s.platform    = Gem::Platform::RUBY
	s.authors     = ["NAME"]
	s.email       = "address@provider.com"
	s.homepage    = "https://test.com/index.html"
	
	s.summary     = "short summary"
	s.description = "\tfull description of the library goes in this section\n\tmany lines of text\n\tso many lines, of so much text\n"
	
	s.required_rubygems_version = ">= 1.3.6"
	
	# lol - required for validation
	#~ s.rubyforge_project         = "newgem"
	
	# If you have other dependencies, add them here
	# s.add_dependency "another", "~> 1.2"
	
	if ENABLE_C_EXTENSION
		s.files        = Dir["{lib}/**/*.rb", "bin/*", "LICENSE", "*.md"]
		s.extensions = ['ext/example/extconf.rb']
	else
		s.files = Dir["{lib}/**/*.rb", "bin/*", "{ext}/**/*.{c,h,rb}", "LICENSE", "*.md"]
	end
	puts s.files
	
	s.require_path = 'lib'
	
	# If you need an executable, add it here
	# s.executables = ["newgem"]
end
