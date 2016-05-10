# green shoes is the gui library we're using.
require 'green_shoes'
require_relative 'instruction'
require_relative 'loopstart'
require_relative 'LoopEnd'
require_relative 'rowmanager'
require_relative 'robotinterface'
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

Shoes.app(width: 900, scroll: true) do
  background "#FDF3E7"

  # @ in ruby means global(instance. this program is one big class) variable. this way functions can access them
  @LABEL_WIDTH = 60
  @INPUT_WIDTH = 40
  @FONT_SIZE = 10

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
  @robotInterface = RobotInterface.new()
  
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

  button "Go" do
    begin
      @robotInterface.execute_commands(@rowManager.get_rows())
    rescue => e
      puts e.backtrace
    end
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
          if row[-1] == "true"
            row[-1] = true
          else #row[-1] == "false"
            row[-1] = false
          end
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

  button "Set Zero" do
    # SP means set position: define its absolute position as the following
    # here we set wherever you are's absolute position as 0
    Process.spawn "screen -S usbserial -X stuff 'SP0\n'"
  end

  button "Erase" do
    if confirm("do you want to erase all your instructions?")
      @rowManager.clear()
      @batch.clear
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

