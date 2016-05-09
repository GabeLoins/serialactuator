# green shoes is the gui library we're using.
require 'green_shoes'
require_relative 'instruction'
require_relative 'loopstart'
require_relative 'LoopEnd'
require_relative 'rowmanager'
# Process.spawn opens an imaginary terminal window and then runs the command
# *it is not blocking, and returns the process id of the new imaginary
# terminal window*

# screen is a terminal program that lets us create a communication channel to
# the anvilator. you can use it in the terminal outside of this application if
# you want to send a quick message to the anvilator without dealing with ruby

# first, we kill the previous screen session. although we also kill it when
# you press close, this is done in case the last session crashed and left a
# running screen session
Process.spawn "screen -X -S usbserial kill"
# then we open a new screen session. /dev/ttyUSB0 is the transmitter to the
# usb serial port
Process.spawn "screen -S usbserial /dev/ttyUSB0 9600"
# this command sends the data after stuff to the open screen connection
Process.spawn "screen -S usbserial -X stuff '\n'"
# this command sends the fudge factor in case it has been lost
Process.spawn "screen -S usbserial -X stuff 'GR2505:1000\n'"

# this sets up a handler that closes our screen session when the user quits
# the gui
at_exit do
  Process.spawn "screen -X -S usbserial kill\n"
end


# # create a new Loop End in the gui
# def new_loop_end()
#   myLoopEnd = LoopEnd.new(@batch)
#   @rowManager.insert_row(myLoopEnd)
# end

# # create a new Loop Start in the gui
# def new_loop_start()
#   myLoopStart = LoopStart.new("", "", @batch)
#   @rowManager.insert_row(myLoopStart)
#   myLoopEnd = LoopEnd.new(@batch)
#   @rowManager.insert_row(myLoopEnd)
# end
# # create a new blank row in the gui
# def new_row()
#   # return 0
#   myRow = Instruction.new("", "", "", "", "", "", @batch)
#   @rowManager.insert_row(myRow)
# end
# @rowManager = RowManager.new(@batch)

# this creates the gui

Shoes.app(width: 900, scroll: true) do
  background "#FDF3E7"

  # @ in ruby means global(instance. this program is one big class) variable. this way functions can access them
  # amt is the row number were at
  @amt = 0
  @LABEL_WIDTH = 60
  @INPUT_WIDTH = 40
  @FONT_SIZE = 10
  # this is a list of the text field objects on the screen
  @texts = []
  @numbers = []
  @radios = []
  @indents = []

  
  # @instructions = []

  # return current absolute position
  def getPosition()
      f = File.new("position.txt", 'w')
      f.close
      Process.spawn "screen -S usbserial -p 0 -X stuff 'blerg\n'"
      Process.spawn "screen -S usbserial -p 0 -X stuff 'tupac is alive\n'"
      Process.spawn "screen -d usbserial"
      Process.spawn "screen -r usbserial -p 0 -X hardcopy position.txt"
      # puts File.read("position.txt")
      # IO.read("position.txt")
      "balls"
  end

  # tell the arm to move to absolute position pos
  def move(acc, dec, ve, pos) 
    Process.spawn "screen -S usbserial -X stuff 'AC#{acc} DE#{dec} VE#{ve} DA#{pos} GO\n'" 
  end 

    # tell the arm to move dist units from its current position
  def move_incremental(acc, dec, ve, dist)
    Process.spawn "screen -S usbserial -X stuff 'AC#{acc} DE#{dec} VE#{ve} DI#{dist} GO\n'"
  end

  def refresh_numbers()
    @numbers.each_with_index{ |field, index| field.text = "#{index + 1}" }
    @amt = @numbers.length
  end

  def refresh_indents()
    puts "refreshing"
    indent_level = 0
    @indents.each{ |indent|
      container, type = indent
      if type == "start"
        indent_level += 1
      end
      
      container.clear()
      container.style(width:0.1*indent_level)

        puts "an indent"
        
        if type == "end"
          indent_level -= 1
        end
    }
    puts "over\n"
  end

  def get_indent_level(_predecessor)
    return 1
  end

  def _get_predecessor()
    for x in @radios do
      break if x.checked?
    end
    if x
      x = x.parent
    end
    return x
  end

  def make_loop_end(_predecessor, _indent_level)
    @batch.after(_predecessor) do
      _row = flow() do
        
        # _indent = [(para "****************************", width: 70, margin: 5), "end"]
        para " Loop End ", width: 40, margin: 5, size: @FONT_SIZE

        _indent_flow = flow do para "bob saget", width: 70, margin: 5 end
        _indents = [ _indent_flow, "end"]

        para " selected ", width: 40, margin: 5, size: @FONT_SIZE
        _selected = radio :selected
        _selected.checked = true

        # workaround for seven data points in a normal row
        _placehold1 = "one"
        _placehold2 = "two"
        _placehold3 = "three"
        _placehold4 = "four"
        _placehold5 = "five"
        _placehold6 = "six"

        button "X" do
          @texts.delete(_placehold1)
          @texts.delete(_placehold2)
          @texts.delete(_placehold3)
          @texts.delete(_placehold4)
          @texts.delete(_placehold5)
          # @texts.delete(_placehold6)

          @radios.delete(_selected)
          @indents.delete(_indents)
          refresh_indents()
          _row.clear()

          # refresh the instruction pool
          @batch.append do end
        end
        # add all the text fields to your list of text fields
        @texts << "loop_end" << _indent_level << _placehold1 << _placehold2 << _placehold3 << _placehold4 << _placehold5 #<< _placehold6
        @radios << _selected
        @indents << _indents
        refresh_indents()
      end
    end
    @batch.append do end
  end

  def make_loop(_iterationstext, _pausetext, _predecessor)
    _indent_level = get_indent_level(_predecessor)
    @batch.after(_predecessor) do
      _row = flow() do
        # _indent = [(para "****************************", width: 70, margin: 5), "start"]
        para " Loop Start ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
        _indent_flow = flow do para "bob saget", width: 70, margin: 5 end
        _indents = [ _indent_flow, "start"]

        para " selected ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
        _selected = radio :selected
        _selected.checked = true
        para " iterations ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
        _iterations = edit_line :width => @INPUT_WIDTH
        _iterations.text = _iterationstext
        para " pause time ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
        _pause = edit_line :width => @INPUT_WIDTH
        _pause.text = _pausetext

        # workaround for seven data points in a normal row
        _placehold1 = "one"
        _placehold2 = "two"
        _placehold3 = "three"
        # _placehold4 = "four"

        button "X" do
          @texts.delete(_iterations)
          @texts.delete(_pause)
          @texts.delete(_indent_level)
          @texts.delete(_placehold1)
          @texts.delete(_placehold2)
          @texts.delete(_placehold3)
          # @texts.delete(_placehold4)
          @radios.delete(_selected)
          @indents.delete(_indents)
          refresh_indents()

          _row.clear()
          # refresh the instruction pool
          @batch.append do end
        end

        # add all the text fields to your list of text fields
        @texts << "loop_start" << _iterations << _pause << _indent_level << _placehold1 << _placehold2 << _placehold3 
        @radios << _selected
        @indents << _indents
        refresh_indents()
      end
    end
    @batch.append do end
  end

  def make_row(_starttext, _endtext, _speedtext, _acceltext, _deceltext, _incrValue, _predecessor)
    @amt = @amt + 1 
    # this means append the following to our list of instructions
    @batch.after(_predecessor) do

      _row = flow() do #scroll: true) do
        _number = para "#{@amt}", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
        _indent_flow = flow do para "bob saget", width: 70, margin: 5 end
        _indents = [ _indent_flow, "row"]
        # _indent = [(para "****************************", width: 70, margin: 5), "row"]
        # para is a text field. #{value} puts a integer into a string
        para " selected ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
        _selected = radio :selected
        _selected.checked = true
        para " Starting ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
        # edit_line creates a text field
        _start = edit_line :width => @INPUT_WIDTH
        # edit_line.text sets the default text inside the text field
        _start.text = _starttext
        para " Ending ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
        _end = edit_line :width => @INPUT_WIDTH
        _end.text = _endtext
        para " Speed ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
        _speed = edit_line :width => @INPUT_WIDTH
        _speed.text = _speedtext
        para " Accel ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
        _accel = edit_line :width => @INPUT_WIDTH
        _accel.text = _acceltext
        para " Decel ", width: @LABEL_WIDTH, margin: 5, size: @FONT_SIZE
        _decel = edit_line :width => @INPUT_WIDTH
        _decel.text = _deceltext
        para " incremental ", width: 90, margin: 5, size: @FONT_SIZE
        _incr = check :width => @INPUT_WIDTH
        _incr = _incrValue
        para "  ", width: @INPUT_WIDTH, margin: 5, size: @FONT_SIZE

        button "X" do
          @texts.delete(_start)
          @texts.delete(_end)
          @texts.delete(_speed)
          @texts.delete(_accel)
          @texts.delete(_decel)
          @texts.delete(_incr)
          @numbers.delete(_number)
          @radios.delete(_selected)
          @indents.delete(_indents)
          refresh_numbers() 
          refresh_indents()
          _row.clear
          # refresh the instruction pool
          @batch.append do end
        end

        # add all the text fields to your list of text fields
        @texts << "command" << _start << _end << _speed << _accel << _decel << _incr << _number
        # @saveData << 
        @radios << _selected
        @numbers << _number
        @indents << _indents
        refresh_indents()
      end
      # _row.append do
        
      # end
    end
    @batch.append do end
  end


  # create a new Loop End in the gui
  def new_loop_end()
    myLoopEnd = LoopEnd.new(@batch)
    @rowManager.insert_row(myLoopEnd)
  end

  # create a new Loop Start in the gui
  def new_loop_start(args = nil)
    if !args.nil?
      # myLoopStart = LoopStart.new(args[0],args[1],@batch)
      myLoopStart = LoopStart.new(*args, @batch)
    else
      myLoopStart = LoopStart.new("", "", @batch)
    end
    @rowManager.insert_row(myLoopStart)
  end

  # create a new blank row in the gui
  def new_row(args = nil)
    if !args.nil?
      # myRow = Instruction.new(args[0],args[1],args[2],args[3],args[4],args[5],@batch)
      myRow = Instruction.new(*args, @batch)
    else
      myRow = Instruction.new("", "", "", "", "", "", @batch)
    end
    @rowManager.insert_row(myRow)
  end

  # create the batch variable which holds all our instruction rows
  @batch = stack do
  end
  @rowManager = RowManager.new(@batch)
  
  # initialize @batch with a single empty row
  new_row()     

  # defines a button. inside the do block is what happens when the button
  # is clicked (in this case we add an empty row)
  button "Add Command" do
    new_row()
  end

  button "Start Loop" do
    new_loop_start()
    new_loop_end()
  end

  button "End Loop" do
    new_loop_end()
  end

  button "Go" do
    # params is now a list of the text inside every text field
    params = @texts.collect{|x| x.text}    
    # each_slice(4) runs following function for each block of 4 text fields
    params.each_slice(6) {|a| 
      # if there is a starting position go there first
      if a[0].strip != ""
        move(1, 1, 20, a[0]) 
      end
      move(a[3], a[4], a[2], a[1])
    } 
  end 
  
  
  button "Save" do
    # ask_save file is built in to shoes and opens a dialogue for a save file
    save_to = ask_save_file
    save_string = @rowManager.get_save_string()
    begin
      File.write(save_to, save_string)
    rescue Exception => e
      puts "FILE_WRITE_ERROR"
      puts e.backtrace
    end
  end
  
  button "Load" do
    @batch.clear()
    @rowManager.clear()
    begin
      load_from = ask_open_file
      contents = File.read(load_from)
      contents = contents.split("\n")
      for row in contents
        row = row.split(",",-1)
        type = row.shift()
        if type == "INSTRUCTION"
          puts row
          new_row(row)
        elsif type == "LOOP_START"
          new_loop_start(row)
        else
          new_loop_end()
        end
      end
      # puts contents
    rescue => e
      puts "FILE_LOAD_ERROR"
      puts e.backtrace
    end
  end

  # button "Load" do
  #   load_from = ask_open_file
  #   contents = File.read(load_from)
  #   contents = contents.split(",")
  #   @texts = []
  #   @batch.clear
  #   @amt = 0
  #   contents.each_slice(7) {|a| 
  #     if a[0] == "command"
  #       make_row(a[1], a[2], a[3], a[4], a[5], a[6])

  #     elsif a[0] == "loop_start"
  #       make_loop(a[1], a[2], a[3])

  #     elsif a[0] == "loop_end" 
  #       make_loop_end(nil)
  #     end
  #   }

  # end

  button "Set Zero" do
    # SP means set position: define its absolute position as the following
    # here we set wherever you are's absolute position as 0
    Process.spawn "screen -S usbserial -X stuff 'SP0\n'"
  end

  button "Erase" do
    if confirm("do you want to erase all your instructions?")
      @texts = []
      @batch.clear
      @amt = 0
      new_row()
    end
  end

  button "Go To Zero" do
    move(1, 1, 20, 0)
  end

  button "print location" do
    puts getPosition()
  end

  # new line
  para ""

  button "Stop", width: 900, height: 200 do
    # CB means clear buffer, the buffer of future instructions
    # K kills the instruction currently being executed
    Process.spawn "screen -S usbserial -X stuff 'CB K\n'"
  end

end

