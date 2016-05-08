class Row
	@LABEL_WIDTH = 60
	@INPUT_WIDTH = 40
	@FONT_SIZE = 10
	def initialize(_batch, order)
		@batch = _batch
		@order = 0
		@selected = true
		@radio = nil
	end
	attr_accessor :selected
	attr_accessor :radio

	def select()
		self.radio.checked = true
	end
	
	def draw(parent)
		order = @order
		me = self
		@batch.app do
			@batch.append() do

		      	_row = flow() do #scroll: true) do
			        
			        _number = para "#{order}", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
			        para " selected ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		    		me.radio = radio :row#; me.selected = true
		    			 # me.selected = true
		    		# end

		    		me.radio.checked = true

			        me.drawFields()

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