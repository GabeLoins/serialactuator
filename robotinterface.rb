class RobotInterface
	
	def initialize()
	end

	# tell the arm to move to absolute position pos
  def move_absolute(acc, dec, ve, pos) 
    Process.spawn "screen -S usbserial -X stuff 'AC#{acc} DE#{dec} VE#{ve} DA#{pos} GO\n'"
    # puts "screen -S usbserial -X stuff 'AC#{acc} DE#{dec} VE#{ve} DA#{pos} GO\n'"
  end 

  def pause(duration)
    Process.spawn "screen -S usbserial -X stuff 'TD#{duration} GO\n'"
  end

    # tell the arm to move dist units from its current position
  def move_incremental(acc, dec, ve, dist)
    Process.spawn "screen -S usbserial -X stuff 'AC#{acc} DE#{dec} VE#{ve} DI#{dist} GO\n'"
  end

  def execute_commands(rows)
      execute_commands_helper(rows)
  end

def execute_commands_helper(rows)
    target = nil
    seek = false
    first = rows[0]
    remaining_iterations = 1
    if first.type == "LOOP_START"
      first = rows.shift()
      remaining_iterations = first.iterations.to_i
    end

    remaining_iterations.times do 
      rows.each_with_index do |row, i|
        if seek == true
          next if row != target
        end
        seek = false

        if row.type == "INSTRUCTION"
          if row.incr == true
            unless row.start.strip == "" # if there is a start position go there first
              move_absolute(1, 1, 20, row.start)
            end
            move_absolute(row.accel, row.decel, row.speed, row.end)
          end
        elsif row.type == "PAUSE"
          pause(row.duration)
        elsif row.type == "LOOP_START"
          loop_start = i
          loop_end = rows.index(row.terminator)
          target = row.terminator
          seek = true
          execute_commands_helper(rows[loop_start..loop_end])
        end
      end
    end
  end
end