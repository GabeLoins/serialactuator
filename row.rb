class Row
	@LABEL_WIDTH = 60
	@ORDER_WIDTH = 20
	@INPUT_WIDTH = 40
	@FONT_SIZE = 10
	def initialize(_batch, order)
		@batch = _batch
		@order = 0
		@selected = true
		@radio = nil
		@indentLevel = 0
		@indentType = 0
	end
	attr_accessor :indentLevel
	attr_accessor :indentType
	attr_accessor :radio
	attr_accessor :order

	def isLoop()
		return 0
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
			        para " selected ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    		me.radio = radio :row#; me.selected = true
		    			 # me.selected = true
		    		# end

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