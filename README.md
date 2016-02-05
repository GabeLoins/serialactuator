# serialanvilator 
===HOW TO RUN===

1. Open the terminal application (looks like ">_")

2. type `anvilator &` (without the quotes) If you don't type the &, the terminal will crash after you close the graphical interface.

4. Follow instructions on screen

5. The instructions you send to the anvilator will be printed out onto the terminal screen you ran `anvilator &` from while the gui is open. This way you can check out what your instructions look like in anvilator-speak

6. after you close the interface, press enter on the terminal to get your terminal prompt back.

===WHERE IS THE CODE?===
The code is in /home/droppr/serialanvilator/app.ruby. It's also hosted on github at https://github.com/GabeLoins/serialanvilator.
===WHAT IF THE TOUCHPAD IS ON/OFF/GOING BESERK?===
If the touchpad on this machine (Acer Aspire E 11) is on, off or going beserk and you want to change that use Fn-F7. Pressing these two keys at the same time will flip the touchpad between on and off. Sometimes, the touchpad will go wild and start moving the mouse around frantically and clicking without you telling it to. In this case, you can calm it down by pressing Fn-F7 twice, once to turn it off and then a second time to turn it back on again. After restarting it it will stop its wild ways and behave well (for the time being).

===FUDGE FACTOR===
Our fudge factor is currently 2505 rotations : 1000 mm.

To change the fudge factor 

1. run /home/droppr/serialanvilator/open_connection_to_anvilator (this lets you send messages to the anvilator)

2. type GR<rotations>:<mm>, for example you could type GR2505:1000

3. press enter

4. press CTRL+a (to tell the connection we are going to issue a command)

5. press k (to quit)

5. press y (to confirm quitting)

6. done!
