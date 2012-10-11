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
    while (check_if_integer(@num_printers) == false)
      @num_printers = gets.chomp
    end
    puts "How many disks do you want to insert?"
    @num_disks = gets.chomp
    while (check_if_integer(@num_disks) == false)
      @num_disks = gets.chomp
    end
    puts "How many rewriteables do you want to insert?"
    @num_rewriteables = gets.chomp
    while (check_if_integer(@num_rewriteables) == false)
      @num_rewriteables = gets.chomp
    end
  end

  def initiate_commands
    while true
      puts "Enter a command in what you want to do:  "
      @command = gets.chomp
      while (check_if_proper_input(@command) == false)
        @command = gets.chomp
      end

      arrival_of_process if @command == 'A'
      snapshot_mode if @command == 'S'
      terminate_process if @command == 't'
      #TODO: Handle the p1 and P1 and the like 
    end
  end

  def snapshot_mode
    puts "Snapshot Mode"
    puts "These are the options you have: r,p,d and c"
    @snapshot_mode_command = gets.chomp
    while (check_if_proper_input_for_snapshot_mode(@snapshot_mode_command) == false)
      @snapshot_mode_command = gets.chomp
    end

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

  def show_pids_processes_in_ready_queue
    puts "Should show pids in the ready queue"
  end

  def show_pids_and_printer_device_queue_info
    puts "show printer info"
  end

  def show_pids_and_disk_device_queue_info
    puts "show disk info"
  end  

  def show_pids_and_rewriteable_device_queue_info
    puts "show rewriteable info"
  end

end 

