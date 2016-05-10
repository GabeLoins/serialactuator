class Row
	@LABEL_WIDTH = 60
	@ORDER_WIDTH = 20
	@INPUT_WIDTH = 40
	@FONT_SIZE = 10
	def initialize(_batch, order)
		@batch = _batch #main stack; can initiate draw calls
		@order = 0
		@selected = true
		@radio = nil
		@indentLevel = 0 #updated dynamically 
		@indentType = 0 #do I change the current indent level?
	end
	attr_accessor :indentLevel
	attr_accessor :indentType
	attr_accessor :radio
	attr_accessor :order
	attr_accessor :type

	def validate()
		return true
	end

	def get_save_string()
		save_string = ""
		save_string << "#{@type}"
		save_string << "\n"
		return save_string
	end

	def select()
		self.radio.checked = true
	end

	def draw(parent, indent, myself)
		order = @order
		self.indentLevel = indent
		me = self
		@batch.app do
			@batch.append() do

		      	_row = flow() do #scroll: true) do
		      		indent.times do
			        	para width: 60, margin: 5
			        end
			        _number = para "#{order}", width: 20, margin: 5, size: @FONT_SIZE
		    		me.radio = radio :row

		    		me.radio.checked = true

			        me.drawFields(myself)

			        button "X" do
			        	parent.remove(me)
			        end
			    end
			end
			# @batch.append do end
		end
	end

	def drawFields(order)
	end
end