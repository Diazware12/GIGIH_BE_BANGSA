class TaskDeterminer
	def task(date, employee_name)
		case date
		when "monday"
			"#{employee_name} implement birthday calculator"
		when "wednesday"
			"#{employee_name} add birthday entries"
		else 
			"#{employee_name} will fix issues"
		end
	end
end