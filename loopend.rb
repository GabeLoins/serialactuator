require_relative "row"

class LoopEnd < Row

	def initialize(_batch)
		super(_batch, 0)
	end

	def drawFields()
		order = @order
		@batch.app do
		    para " Loop End ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
	        # _indent_flow = flow do para "bob saget", width: 70, margin: 5 end
	        # _indents = [ _indent_flow, "start"]
		end
	end
end