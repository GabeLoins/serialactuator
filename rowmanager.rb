require_relative "row"

class RowManager
	
	def initialize(batch)
		@batch = batch
		@rows = []
	end

	def insert_row(newRow)
	    if @rows.empty? # Add to front of instructions list
	    	@rows.push(newRow)
	    else # insert after selected instruction
	    	index = get_selected_row_index()
	    	@rows.insert(index+1,newRow)
	    end
	    draw()
	    newRow.select()
	end

	def remove(instruction)
		@rows.delete(instruction)
		draw()
	end

	# refresh gui maintaining current selection
	def draw()
		index = get_selected_row_index()
		@batch.app do
			@batch.clear()
		end
		for instruction in @rows do
			instruction.draw(self)
		end
		if not @rows.empty?()
			@rows[index].select()
		end
	end

	def get_selected_row_index()
		# return 0
		if @rows.size <= 1
			return 0
		end
		@rows.each_with_index do |row, i|
			if row.radio.checked?
				return i
			end
		end
	end
end