require './helpers'
require 'thread'
require './pcb'
require './ready_queue'
require './cpu'

class Os
  include Helpers

  attr_accessor :num_printers, :num_disks, :num_rewriteables, :command 

  def initialize
    @os_ready_queue = ReadyQueue.new
    @os_cpu = Cpu.new

    puts "Welcome to your OS"
    
    puts "How many printers do you want to insert?"
    @num_printers = gets.chomp
    @num_printers = gets.chomp while (check_if_integer(@num_printers) == false)

    puts "How many disks do you want to insert?"
    @num_disks = gets.chomp
    @num_disks = gets.chomp while (check_if_integer(@num_disks) == false)
    
    puts "How many rewriteables do you want to insert?"
    @num_rewriteables = gets.chomp
    @num_rewriteables = gets.chomp while (check_if_integer(@num_rewriteables) == false)

    #TODO: Do something if this is true 
    puts "you created no devices" if (check_if_all_are_zeros(@num_printers.to_i, @num_rewriteables.to_i, @num_disks.to_i) == 0)

    generate_printers(@num_printers.to_i)
    generate_disks(@num_disks.to_i)
    generate_rewriteables(@num_rewriteables.to_i)

  end

  def initiate_commands
    while true
      puts "Enter a command in what you want to do:  "
      @command = gets.chomp
      @command = gets.chomp while (check_if_proper_input(@command) == false)
      arrival_of_process if @command == 'A'
      snapshot_mode if @command == 'S'
      terminate_process if @command == 't'
      handle_system_request(@command) if /[pcdPCD]/.match(@command[0])
    end
  end

  def snapshot_mode
    puts "Snapshot Mode"
    puts "These are the options you have: r,p,d and c"
    @snapshot_mode_command = gets.chomp
    @snapshot_mode_command = gets.chomp while (check_if_proper_input_for_snapshot_mode(@snapshot_mode_command) == false)
    show_pids_processes_in_ready_queue if @snapshot_mode_command == 'r'
    show_pids_and_printer_device_queue_info if @snapshot_mode_command == 'p'
    show_pids_and_disk_device_queue_info if @snapshot_mode_command == 'd'
    show_pids_and_rewriteable_device_queue_info if @snapshot_mode_command == 'c'

  end

  def arrival_of_process
    new_pcb = Pcb.new
    @os_ready_queue.enqueue_pcb(new_pcb)
    puts "the number of pcb's in the Ready Queue #{@os_ready_queue.get_ready_queue_length}"
    @os_cpu.insert_to_cpu(@os_ready_queue.dequeue_pcb) if @os_cpu.get_cpu_length == 0
    puts "the number of pcb's in the CPU: #{@os_cpu.get_cpu_length}"
  end

  def terminate_process
    puts "terminate process"
  end

  private

  def generate_printers(num)
    @printers = Queue.new
    num.times{ @printers << Printer.new }
  end

  def generate_disks(num)
    @disks = Queue.new
    num.times{ @disks << Disk.new } 
  end

  def generate_rewriteables(num)
    @rewriteables = Queue.new
    num.times{ @rewriteables << Rewriteable.new }
  end

  def handle_system_request(param)
    @request = param.partition(/[pcd]/i).reject!{ |c| c.empty? }
    system_call(@request[0], @request[1].to_i) if check_if_its_upper(@request[0]) == false
    signal_completion(@request[0], @request[1].to_i) if check_if_its_upper(@request[0]) == true
  end

  def system_call(device, num)
    puts "made it to system call"
    puts "this is the number of PCB #{num}"
    puts "this is the device of PCB #{device}"
  end

  def signal_completion(device, num)
    puts "made it to completion"
    puts "this is the number of PCB #{num}"
    puts "this is the device of PCB #{device}"
  end
  
  def show_pids_processes_in_ready_queue
    puts "Should show pids in the ready queue"
  end

  def show_pids_and_printer_device_queue_info
    puts "#{@printers.length} is the number of printers in the  queue"
  end

  def show_pids_and_disk_device_queue_info
    puts "#{@disks.length} is the number of disks in the  queue"
  end  

  def show_pids_and_rewriteable_device_queue_info
    puts "#{@rewriteables.length} is the number of rewriteables in the queue"
  end

end 

