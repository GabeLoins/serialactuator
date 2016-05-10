require_relative "row"

class RowManager
	
	def initialize(batch)
		@batch = batch
		@rows = []
	end

	def get_rows()
		unless validate_rows()
			return nil
		end
		for row in @rows
			if row.type == "LOOP_START"
				row.terminator = get_loop_pair(row)
			end
		end
		draw()
		return @rows
	end
	
	def validate_rows()
		result = true
		for row in @rows
			unless row.validate()
				result = false
			end
		end
		return result
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

	def clear()
		@rows = []
	end

	def remove(row)
		begin
		partner = get_loop_pair(row) # terminate loop start end pairs together
		if not partner.nil?
			@rows.delete(partner)
		end

		@rows.delete(row)
		draw()
		rescue Exception => e
  			puts e.backtrace

		end
	end

	def get_loop_pair(row)
		if row.indentType == 0
			return nil
		end

		index = get_row_index(row)
		len = @rows.size - 1
		if row.indentType < 0 # end loop
			@rows.reverse.each_with_index do |anotherRow, i|
				next if len - i >= index || anotherRow.indentType == 0
				if anotherRow.indentLevel == row.indentLevel
					return anotherRow
				end
			end
		elsif row.indentType > 0 # start loop
			@rows.each_with_index do |anotherRow, i|
				next if i <= index || anotherRow.indentType == 0
				if anotherRow.indentLevel == row.indentLevel
					return anotherRow
				end
			end
		end
	end

	# refresh gui maintaining current selection
	def draw()
		index = get_selected_row_index()
		@batch.app do	
			@batch.clear()
		end
		indent = 0
		order = 1
		for instruction in @rows do
			if instruction.indentType > 0
				indent += instruction.indentType
			end
			instruction.order = order
			order += 1
			instruction.draw(self, indent, instruction)
			if instruction.indentType < 0
				indent += instruction.indentType
			end
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
		return 0
	end

	def get_row_index(row)
		@rows.each_with_index do |aRow, i|
			if aRow == row
				return i
			end
		end
	end

	def get_save_string()
		save_string = ""
		for row in @rows
			save_string << row.get_save_string()
		end
		return save_string
	end
end