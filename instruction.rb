require_relative "row"

class Instruction < Row

	def initialize( _endtext, _speedtext, _acceltext, _deceltext, _incrValue, _batch)
		super(_batch, 0)
		puts _incrValue
		# @start = _starttext
		@end = _endtext
		@speed = _speedtext
		@accel = _acceltext
		@decel = _deceltext
		@incr = _incrValue
		@type = "INSTRUCTION"
	end
	# attr_accessor :start
	attr_accessor :end
	attr_accessor :speed
	attr_accessor :accel
	attr_accessor :decel
	attr_accessor :incr

	def get_save_string()
		save_string = ""
		save_string << "#{@type}," << "#{@end}," << "#{@speed}," << "#{@accel}," << "#{@decel}," <<"#{@incr}" << "\n"
		return save_string
	end

	def drawFields(me)
		me = self
		@batch.app do
		    # para is a text field. #{value} puts a integer into a string
		   	para " Destination / Distance ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _end = edit_line :width => @INPUT_WIDTH do |i| me.end = i.text end
		    _end.text = me.end
		    para " Speed ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _speed = edit_line :width => @INPUT_WIDTH do |i| me.speed = i.text end
		    _speed.text = me.speed
		    para " Accel ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _accel = edit_line :width => @INPUT_WIDTH do |i| me.accel = i.text end
		    _accel.text = me.accel
		    para " Decel ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _decel = edit_line :width => @INPUT_WIDTH do |i| me.decel = i.text end
		    _decel.text = me.decel
		    para " incremental ", width: 90, margin: 5, size: @FONT_SIZE
		    _incr = check :width => @INPUT_WIDTH do |i| me.incr = i.checked? end
		    _incr.checked = me.incr
		    para "  ", width: @INPUT_WIDTH, margin: 5, size: @FONT_SIZE
		end
	end
end