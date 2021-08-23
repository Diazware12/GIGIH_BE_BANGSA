class Employee

	attr_accessor :first_name, :last_name, :working_level, :tax

	def initialize(first_name, last_name, working_level, tax)
		@first_name = first_name
		@last_name = last_name
		@working_level = working_level
		@tax = tax
	end

	def full_name
		"#{first_name} #{last_name}"
	end

end