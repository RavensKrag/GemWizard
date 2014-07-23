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