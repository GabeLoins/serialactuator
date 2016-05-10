require_relative "row"

class Pause < Row
	
	def initialize(_durationtext, _batch)
		super(_batch, 0)
		@duration = _durationtext
		@type = "PAUSE"
	end
	attr_accessor :duration

	def validate()
		error = false
		unless @duration.to_f.to_s == @duration
			error = true
		end
		unless @duration.to_f > 0
			error = true
		end
		if error
			me = self
			@batch.app do
				alert("Invalid pause value on line #{me.order}.\nPause values should be greater than 0")
				return false
			end
		end
		return true
	end

	def get_save_string()
		save_string = ""
		save_string << "#{@type},"
		save_string << "#{@duration}" << "\n"
		return save_string
	end

	def drawFields(me)
		me = self
		@batch.app do
			para " Pause ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
			para " Duration ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    _duration = edit_line :width => @INPUT_WIDTH do |i| me.duration = i.text end
		    _duration.text = me.duration
		end
	end
end