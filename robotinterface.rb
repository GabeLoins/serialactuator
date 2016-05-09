class RobotInterface
	
	def initialize()
	end

	# tell the arm to move to absolute position pos
  def move_absolute(acc, dec, ve, pos) 
    Process.spawn "screen -S usbserial -X stuff 'AC#{acc} DE#{dec} VE#{ve} DA#{pos} GO\n'" 
  end 

    # tell the arm to move dist units from its current position
  def move_incremental(acc, dec, ve, dist)
    Process.spawn "screen -S usbserial -X stuff 'AC#{acc} DE#{dec} VE#{ve} DI#{dist} GO\n'"
  end

  def execute_commands(rows)
  	for row in rows
  		if row.type == "INSTRUCTION"
  			if row.incr == true

  			end
  		end
  	end
  end
end