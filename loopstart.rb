require_relative "row"

class LoopStart < Row

	def drawFields()
		order = @order
		@batch.app do
		    para " Loop Start ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
	        _indent_flow = flow do para "bob saget", width: 70, margin: 5 end
	        _indents = [ _indent_flow, "start"]

	        para " selected ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
	        _selected = radio :selected
	        _selected.checked = true
	        para " iterations ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
	        _iterations = edit_line :width => @INPUT_WIDTH
	        _iterations.text = _iterationstext
	        para " pause time ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
	        _pause = edit_line :width => @INPUT_WIDTH
	        _pause.text = _pausetext
		end
	end
end