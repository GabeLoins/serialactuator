require_relative "row"

class LoopStart < Row

	def initialize(_iterationstext, _pausetext, _batch)
		super(_batch, 0)
		@indentType = 1
		@iterations = _iterationstext
		@pauseDuration = _pausetext
		@type = "LOOP_START"
		@elements = [@iterations, @pauseDuration]
		@terminator = nil
	end
	attr_accessor :iterations
	attr_accessor :pauseDuration
	attr_accessor :terminator

	def validate()
		error = false
		if !@iterations.is_a? Integer || @iterations <= 0
			puts @iterations
			error = true
		end
		if !@pauseDuration.is_a? Integer || @pauseDuration < 0
			puts @pauseDuration
			error = true
		end
		if error
			me = self
			@batch.app do
				alert("Invalid value entered for loop on line #{me.order}")
			end
		end
	end

	def get_save_string()
		save_string = ""
		save_string << "#{@type},"
		save_string << "#{@iterations}," << "#{@pauseDuration}" << "\n"
		return save_string
	end

	def drawFields(me)
		@batch.app do
		    para " Loop Start ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE

	        para " iterations ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
	        _iterations = edit_line :width => @INPUT_WIDTH do |i| me.iterations = i.text.to_i end
	        _iterations.text = me.iterations.to_s
	        para " pause time ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
	        _pause = edit_line :width => @INPUT_WIDTH do |i| me.pauseDuration = i.text.to_i end
	        _pause.text = me.pauseDuration.to_s
		end
	end
end