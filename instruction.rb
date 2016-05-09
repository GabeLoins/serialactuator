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
	attr_accessor :start
	attr_accessor :end
	attr_accessor :speed
	attr_accessor :accel
	attr_accessor :decel
	attr_accessor :incr

	def drawFields(me)
		myStart = @start
		@batch.app do
		    # _indent_flow = flow do para "", width: 70, margin: 5 end
		    # _indents = [ _indent_flow, "row"]
		    # _indent = [(para "****************************", width: 70, margin: 5), "row"]
		    # para is a text field. #{value} puts a integer into a string
		    para " Starting ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    # edit_line creates a text field
		    _start = edit_line :width => @INPUT_WIDTH do |i| me.start = i.text end
		    # edit_line.text sets the default text inside the text field
		    _start.text = me.start
		    para " Ending ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _end = edit_line :width => @INPUT_WIDTH do |i| me.end = i.text end
		    _end.text = me.end
		    para " Speed ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _speed = edit_line :width => @INPUT_WIDTH do |i| me.speed = i.text end
		    _speed.text = me.speed
		    para " Accel ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _accel = edit_line :width => @INPUT_WIDTH do |i| me.accel = i.text end
		    _accel.text = me.accel
		    para " Decel ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZ
		    _decel = edit_line :width => @INPUT_WIDTH do |i| me.decel = i.text end
		    _decel.text = me.decel
		    para " incremental ", width: 90, margin: 5, size: @FONT_SIZE
		    _incr = check :width => @INPUT_WIDTH do |i| me.incr = i.checked? end
		    _incr = me.incr
		    para "  ", width: @INPUT_WIDTH, margin: 5, size: @FONT_SIZE
		end
	end
end