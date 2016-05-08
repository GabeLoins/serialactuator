require_relative "row"

class Instruction < Row

	def initialize(_starttext, _endtext, _speedtext, _acceltext, _deceltext, _incrValue, _batch)
		super(_batch, 0)
		@start = _starttext
		@end = _endtext
		@speed = _speedtext
		@accel = _acceltext
		@decel = _deceltext
		@incr = _incrValue
	end

	def drawFields()
		order = @order
		@batch.app do
		    # _indent_flow = flow do para "", width: 70, margin: 5 end
		    # _indents = [ _indent_flow, "row"]
		    # _indent = [(para "****************************", width: 70, margin: 5), "row"]
		    # para is a text field. #{value} puts a integer into a string
		    para " Starting ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    # edit_line creates a text field
		    _start = edit_line :width => @INPUT_WIDTH
		    # edit_line.text sets the default text inside the text field
		    _start.text = @start
		    para " Ending ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _end = edit_line :width => @INPUT_WIDTH
		    _end.text = @end
		    para " Speed ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _speed = edit_line :width => @INPUT_WIDTH
		    _speed.text = @speed
		    para " Accel ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _accel = edit_line :width => @INPUT_WIDTH
		    _accel.text = @accel
		    para " Decel ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _decel = edit_line :width => @INPUT_WIDTH
		    _decel.text = @decel
		    para " incremental ", width: 90, margin: 5, size: @FONT_SIZE
		    _incr = check :width => @INPUT_WIDTH
		    _incr = @incr
		    para "  ", width: @INPUT_WIDTH, margin: 5, size: @FONT_SIZE
		end
	end
end