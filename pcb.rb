require './helpers'

class Pcb
  include Helpers
  attr_accessor :file_name, :location_memory, :read_or_write, :p_id

  def initialize(pid)
    puts "created a PCB"
    @p_id = pid
    puts "p id number is #{@p_id}"
  end
  
  def passed_to_device_queue_is_printer
    puts "What is the file name?"
    @file_name = gets.chomp
    puts "What memory location?"
    @location_memory = gets.chomp
    @location_memory = gets.chomp while (check_if_integer(@location_memory) == false)
    @read_or_write = "write"
  end

  def passed_to_device_queue
    puts "What is the file name?"
    @file_name = gets.chomp
    puts "What memory location?"
    @location_memory = gets.chomp
    @location_memory = gets.chomp while (check_if_integer(@location_memory) == false)
    puts "Is it a read or write?"
    @read_or_write = gets.chomp
    @read_or_write = gets.chomp while (check_if_read_or_write(@read_or_write) == false)
  end
end
