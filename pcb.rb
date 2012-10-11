require './helpers'

class Pcb
  include Helpers
  attr_accessor :file_name, :location_memory, :read_or_write

  def initialize
    puts "created a PCB"
  end
  
  def passed_to_device_queue
    puts "What is the file name?"
    @file_name = gets.chomp
    puts "What memory location?"
    @location_memory = gets.chomp
    while (check_if_integer(@location_memory) == false)
      @location_memory = gets.chomp
    end
    puts "Is it a read or write?"
    @read_or_write = gets.chomp
  end

end

class Printerpcb < Pcb

  def initialize
    @read_or_write = "read"
  end

  def passed_to_device_queue
    puts "What is the file name?"
    @file_name = gets.chomp
    puts "What memory location?"
    @location_memory = gets.chomp
  end

end

class Diskpcb < Pcb
end

class Rewriteablepcb < Pcb
end
