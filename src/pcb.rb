require './helpers'

class Pcb
  include Helpers
  attr_accessor :file_name, :location_memory, :read_or_write, :p_id, :size_of_file

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
    @read_or_write = "w"
    puts "Enter the size of this size of this file that will go to the printer"
    @size_of_file = gets.chomp
    @size_of_file = gets.chomp while (check_if_integer(@size_of_file) == false)
  end

  def passed_to_device_queue
    puts "What is the file name?"
    @file_name = gets.chomp
    puts "What memory location?"
    @location_memory = gets.chomp
    @location_memory = gets.chomp while (check_if_integer(@location_memory) == false)
    puts "Is it a read or write (r/w)?"
    @read_or_write = gets.chomp
    @read_or_write = gets.chomp while (check_if_read_or_write(@read_or_write) == false)
    if @read_or_write == 'w'
      puts "Enter the size of this file:"
      @size_of_file = gets.chomp
      @size_of_file = gets.chomp while (check_if_integer(@size_of_file) == false)
    end
  end
end
