require_relative "row"

class Instruction < Row

	def initialize( _endtext, _speedtext, _acceltext, _deceltext, _incrValue, _batch)
		super(_batch, 0)
		puts _incrValue
		# @start = _starttext
		@end = _endtext.to_i
		@speed = _speedtext.to_i
		@accel = _acceltext.to_i
		@decel = _deceltext.to_i
		@incr = _incrValue
		@type = "INSTRUCTION"
	end
	# attr_accessor :start
	attr_accessor :end
	attr_accessor :speed
	attr_accessor :accel
	attr_accessor :decel
	attr_accessor :incr

	def validate()
		fields = [ @speed, @accel, @decel]
		unless fields.all? {|field| field > 0}
			me = self
			@batch.app do
				alert("one or more fields on line #{me.order} are zero")
			end
			return false
		end
		return true
	end

	def get_save_string()
		save_string = ""
		save_string << "#{@type}," << "#{@end}," << "#{@speed}," << "#{@accel}," << "#{@decel}," <<"#{@incr}" << "\n"
		return save_string
	end

	def drawFields(me)
		me = self
		@batch.app do
		    # para is a text field. #{value} puts a integer into a string
		    if me.incr
		   		para " Distance ", width: 85, margin: 5, size: @FONT_SIZE
		   	else
		   		para " Destination ", width: 85, margin: 5, size: @FONT_SIZE
		   	end
		    _end = edit_line :width => @INPUT_WIDTH do |i| me.end = i.text.to_i end
		    _end.text = me.end.to_s
		    para " Speed ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _speed = edit_line :width => @INPUT_WIDTH do |i| me.speed = i.text.to_i end
		    _speed.text = me.speed.to_s
		    para " Accel ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _accel = edit_line :width => @INPUT_WIDTH do |i| me.accel = i.text.to_i end
		    _accel.text = me.accel.to_s
		    para " Decel ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _decel = edit_line :width => @INPUT_WIDTH do |i| me.decel = i.text.to_i end
		    _decel.text = me.decel.to_s
		    para " incremental ", width: 90, margin: 5, size: @FONT_SIZE
		    _incr = check :width => @INPUT_WIDTH do |i| me.incr = i.checked? end
		    _incr.checked = me.incr
		    para "  ", width: @INPUT_WIDTH, margin: 5, size: @FONT_SIZE
		end
	end
end