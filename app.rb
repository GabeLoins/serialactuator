# green shoes is the gui library we're using.
require 'green_shoes'

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

# this creates the gui
Shoes.app(width: 900) do
  background "#FDF3E7"
  # @ in ruby means global(instance. this program is one big class) variable. this way functions can access them
  # amt is the row number were at
  @amt = 0
  # this is a list of the text field objects on the screen
  @texts = []
  @numbers = []
  @radios = []

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

  def _get_predecessor()
    for x in @radios do
      break if x.checked?
    end
    if x
      x = x.parent
    end
    return x
  end

  def new_end_loop()
    x = 53
  end
  
  def new_loop()
    make_loop("", "", _get_predecessor())
  end

  def make_loop(_iterationstext, _pausetext, _predecessor)
    @batch.after(_predecessor) do
      _row = flow do
        para " Loop Start ", width: 70, margin: 5
        para " iterations ", width: 70, margin: 5
        _iterations = edit_line :width => 30
      end
    end
  end

   # create a new blank row in the gui
  def new_row()
    make_row("", "", "", "", "", "", _get_predecessor())
  end

  def make_row(_starttext, _endtext, _speedtext, _acceltext, _deceltext, _incrValue, _predecessor)
    @amt = @amt + 1 
    # this means append the following to our list of instructions
    @batch.after(_predecessor) do
      puts "new row!"
      _row = flow do
        para "  ", width: 70, margin: 5
        # para is a text field. #{value} puts a integer into a string
        _number = para "#{@amt}", width: 70, margin: 5
        para " selected ", width: 70, margin: 5
        _selected = radio :selcted
        _selected.checked = true
        para " Starting ", width: 90, margin: 5
        # edit_line creates a text field
        _start = edit_line :width => 70
        # edit_line.text sets the default text inside the text field
        _start.text = _starttext
        para " Ending ", width: 70, margin: 5
        _end = edit_line :width => 70
        _end.text = _endtext
        para " Speed ", width: 70, margin: 5
        _speed = edit_line :width => 70
        _speed.text = _speedtext
        para " Accel ", width: 70, margin: 5
        _accel = edit_line :width => 70
        _accel.text = _acceltext
        para " Decel ", width: 70, margin: 5
        _decel = edit_line :width => 70
        _decel.text = _deceltext
        para " incremental ", width: 90, margin: 5
        _incr = check :width => 70
        _incr = _incrValue
        para "  ", width: 40, margin: 5

        button "X" do
          @texts.delete(_start)
          @texts.delete(_end)
          @texts.delete(_speed)
          @texts.delete(_accel)
          @texts.delete(_decel)
          @texts.delete(_incr)
          @numbers.delete(_number)
          @radios.delete(_selected)
          refresh_numbers() 
          _row.clear
          # refresh the instruction pool
          @batch.append do end
        end

        # add all the text fields to your list of text fields
        @texts << _start << _end << _speed << _accel << _decel << _incr
        @radios << _selected
        @numbers << _number
      end
    end
  end

  # create the batch variable which holds all our instruction rows
  @batch = stack do
  end
  # initialize @batch with a single empty row
  new_row()     

  # defines a button. inside the do block is what happens when the button
  # is clicked (in this case we add an empty row)
  button "Add Command" do
    new_row()
  end

  button "Start Loop" do
    new_loop()
  end

  button "End Loop" do
    new_end_loop()
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
    params = @texts.collect{|x| x.text}.join(",")    
    File.open(save_to, 'w') { |file| file.write(params) }
  end
  
  button "Load" do
    load_from = ask_open_file
    contents = File.read(load_from)
    contents = contents.split(",")
    @texts = []
    @batch.clear
    @amt = 0
    contents.each_slice(6) {|a| make_row(a[0], a[1], a[2], a[3], a[4], a[5])}
  end

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
