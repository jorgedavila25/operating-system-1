require './helpers'

class Pcb
  include Helpers
  attr_accessor :file_name, :location_memory, :read_or_write, :p_id, :size_of_file, :cylinder_num, :time_spent_in_cpu

  def initialize(pid)
    @time_spent_in_cpu = 0
    @bursts = Array.new
    puts "created a PCB"
    @p_id = pid
    puts "p id number is #{@p_id}"
  end

  def burst_occurs
    @bursts << @time_spent_in_cpu
  end 

  def compute_average_burst_time
    @bursts.inject{ |sum, x| sum + x }.to_f / @bursts.size
  end

  def passed_to_device_queue_is_printer
    puts "What is the file name?"
    @file_name = gets.chomp
    puts "What memory location?"
    @location_memory = gets.chomp.to_i
    @location_memory = gets.chomp while (check_if_integer(@location_memory.to_i) == false)
    @read_or_write = "w"
    puts "Enter the size of this size of this file that will go to the printer"
    @size_of_file = gets.chomp.to_i
    @size_of_file = gets.chomp.to_i while (check_if_integer(@size_of_file.to_i) == false)
  end

  def passed_to_device_queue_is_disk(num_of_cylinders)
    puts "What is the file name?"
    @file_name = gets.chomp
    puts "What memory location?"
    @location_memory = gets.chomp.to_i
    @location_memory = gets.chomp.to_i while (check_if_integer(@location_memory.to_i) == false)
    puts "What's the cylinder location?"
    @cylinder_num = gets.chomp.to_i
    @cylinder_num = gets.chomp.to_i while (check_if_in_cylinder_bounds(@cylinder_num.to_i, num_of_cylinders.to_i) == false)
    puts "Is it a read or write (r/w)?"
    @read_or_write = gets.chomp
    @read_or_write = gets.chomp while (check_if_read_or_write(@read_or_write) == false)
    if @read_or_write == 'w'
      puts "Enter the size of this file:"
      @size_of_file = gets.chomp.to_i
      @size_of_file = gets.chomp.to_i while (check_if_integer(@size_of_file) == false)
    end    
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
