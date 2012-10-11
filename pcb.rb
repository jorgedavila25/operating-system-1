require './helpers'

class Pcb
  include Helpers
  attr_accessor :file_name, :location_memory, :read_or_write

  def initialize(pid)
    puts "created a PCB"
    @p_id = pid
    puts "p id number is #{@p_id}"
  end
  
  def passed_to_device_queue
    puts "What is the file name?"
    @file_name = gets.chomp
    puts "What memory location?"
    @location_memory = gets.chomp
    @location_memory = gets.chomp while (check_if_integer(@location_memory) == false)
    puts "Is it a read or write?"
    @read_or_write = gets.chomp
  end

end

class Printerpcb < Pcb

  def passed_to_device_queue
    puts "What is the file name?"
    @file_name = gets.chomp
    puts "What memory location?"
    @location_memory = gets.chomp
    @location_memory = gets.chomp while (check_if_integer(@location_memory) == false)
  end

end

class Diskpcb < Pcb
end

class Rewriteablepcb < Pcb
end
