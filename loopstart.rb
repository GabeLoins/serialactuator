require_relative "row"

class LoopStart < Row

	def initialize(_iterationstext, _pausetext, _batch)
		super(_batch, 0)
		@indentType = 1
		@iterations = _iterationstext
		@pauseDuration = _pausetext
		@type = "LOOP_START"
		@elements = [@iterations, @pauseDuration]
	end
	attr_accessor :iterations
	attr_accessor :pauseDuration

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
	        _iterations = edit_line :width => @INPUT_WIDTH do |i| me.iterations = i.text end
	        _iterations.text = me.iterations
	        para " pause time ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
	        _pause = edit_line :width => @INPUT_WIDTH do |i| me.pauseDuration = i.text end
	        _pause.text = me.pauseDuration
		end
	end
end