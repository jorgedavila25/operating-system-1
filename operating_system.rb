require './helpers'
require 'thread'
require './pcb'
require './ready_queue'
require './cpu'

=begin
  this is where all the logic will go
=end 
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
      if @command == 'A'
        arrival_of_process
      elsif @command == 'S'
        snapshot_mode
      elsif @command == 't'
        terminate_process
      else
        "This command is only available in snapshot mode, please try again"
      end
    end
  end

  def snapshot_mode
    puts "snapshot "
  end

  def arrival_of_process
    new_pcb = Pcb.new
    @os_ready_queue.enqueue_pcb(new_pcb)
    @os_cpu.insert_to_cpu(@os_ready_queue.pop) if @os_cpu.get_ready_cpu_length == 0
  end

  def terminate_process

  end

end 

