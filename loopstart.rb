require_relative "row"

class LoopStart < Row

	def initialize(_iterationstext, _pausetext, _batch)
		super(_batch, 0)
		@iterations = _iterationstext
		@pauseDuration = _pausetext
	end

	def drawFields()
		order = @order
		@batch.app do
		    para " Loop Start ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
	        # _indent_flow = flow do para "bob saget", width: 70, margin: 5 end
	        # _indents = [ _indent_flow, "start"]
	        
	        para " iterations ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
	        _iterations = edit_line :width => @INPUT_WIDTH
	        _iterations.text = @iterations
	        para " pause time ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
	        _pause = edit_line :width => @INPUT_WIDTH
	        _pause.text = @pauseDuration
		end
	end
end