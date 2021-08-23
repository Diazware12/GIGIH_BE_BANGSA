class Payment

    attr_accessor :input, :tax

	def initialize(params)
        input: params['input'],
        tax: params['tax']
	end

    def compute
		case working_level
		when @input == 1
			3000000 - (3000000 * @tax)
		when @input == 2
			4000000 - (4000000 * @tax)
		when @input == 3
			5000000 - (5000000 * @tax)
		else "unknown level"
		end
	end
end