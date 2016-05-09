require_relative "row"

class LoopEnd < Row

	def initialize(_batch)
		super(_batch, 0)
		@indentType = -1
	end

	def drawFields(me)
		order = @order
		@batch.app do
		    para " Loop End ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
		end
	end
end