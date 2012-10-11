require './cpu'
require './pcb'
require './operating_system'
require './ready_queue'
require './device'
require 'thread'

=begin
	Program needs to have two stages of operation:  1. "Sys Gen" Section (this is the user operating the program)
														* Specifies how many devices of each type (3 types) are in the system
															- Printer
															- Disk
															- CD/RW
														* Only one CPU	
													2. "Running" Section
														* Handle system calls issued by the processes currently controlling the CPU as
														  well as interrupts that signal various system events. (by keyboard input)
															- Capital case letters will indicate interrupts
															- Lower case letters will indicate system calls
														* Interrupts will be handled atomically
															- One can not interrupt an interrupt handling routine
	Commands:   "A" => indicates the arrival of a process
					- Handling routine should create a PCB for this process, generate a PID, and enqueue the PCB into the Ready Queue
					- If CPU is not occupied, the first process in the Ready Queue should be passed to the CPU
				"t" => the process in the CPU can issue system calls. 't' indicate that the process is terminating
					- The OS should recycle the PCB (but not the PID), aka reclaim the now unused memory
				"S" => this indicates a SnapShot interrupt
					-The handling routine should wait for the next keyboard input:
						* "r" => show the PIDs of the processes in the Ready Queue
						* "p" => show the PIDs and printer specific information of the processes in the printer queues
						* "d" => show the PIDs and disks specific information of the processes in the printer queues
						* "c" => show the CD/RW queues

	Terminology:
				Process Control (PCB) = Each process is represented in the OS by a PCB - also called a 'task control block'

=end

new_os = Os.new

new_os.initiate_commands

