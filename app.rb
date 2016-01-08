require 'green_shoes'

=begin
port_str = "/dev/cu.usbserial"
baud_rate = 9600
data_bits = 8
stop_bits = 1
parity = SerialPort::NONE

puts "here"
sp = SerialPort.new(port_str, baud_rate, data_bits, stop_bits, parity)
puts sp
spp = open(sp)
puts "there"
out = sp.write('AC1 VE20 DI100 GO')
puts out
puts "done"
=end

Process.spawn "screen -X -S usbserial kill"
Process.spawn "screen -S usbserial /dev/cu.usbserial 9600"
Process.spawn "screen -S usbserial -X stuff $'\n'"
# pid = `screen -list | grep usbserial | cut -f1 -d'.' | sed 's/\W//g' | sed 's/[[:space:]]//g'`

at_exit do
  Process.spawn "screen -X -S usbserial kill\n"
end

Shoes.app(width: 850) do
  background "#FDF3E7"
  @amt = 0
  @texts = []

  def move(acc, ve, pos) 
    Process.spawn "screen -S usbserial -X stuff $'AC#{acc} VE#{ve} DA#{pos} GO\n'" 
  end 

  def new_row()
    make_row("", "", "", "")
  end

  def make_row(_starttext, _endtext, _speedtext, _acceltext)
    @amt = @amt + 1
    @batch.append do
      flow() do
        para "#{@amt}", width: 70, margin: 5
        para " Starting ", width: 70, margin: 5
        _start = edit_line :width => 70
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
        @texts << _start << _end << _speed << _accel
      end
    end
  end

  @batch = stack do
  end
  new_row()

  button "Add" do
    new_row()
  end

  button "Go" do
    params = @texts.collect{|x| x.text}    
    params.each_slice(4) {|a| 
      move(1, 20, a[0]) 
      move(a[3], a[2], a[1])
    } 
    mouse_move(50,50)
  end 
  

  button "Save" do
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
    contents.each_slice(4) {|a| make_row(a[0], a[1], a[2], a[3])}
  end

  para ""

  button "Stop", width: 850, height: 200 do
    Process.spawn "screen -S usbserial -X stuff $'CB S\n'"
  end

end
