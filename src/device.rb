require 'thread'
require './helpers'

class Device
  include Helpers
  
  def initialize
    @queue = Queue.new
  end

  def enqueue_device(pcb)
    @queue << pcb
  end

  def c_look_algorithm

  end

  def dequeue_device
    @queue.pop
  end

  def number_of_pcb_in_device
    @queue.length
  end
  #  device  | p_id  | file_name  |  R/W  |  Size  |  CPU Time  |  Avg Burst Time  
  #  ============================================================================
  def view_device(i)
    return puts "#{device}'s #{i} queue is empty" if @queue.empty?
    # TODO Make sure printing devices do not exceed 23 lines
    @queue.length.times do
      temp = @queue.pop
      puts "PCB with p_id: #{temp.p_id} is in #{device} #{i}"
      puts "File: #{temp.file_name}"
      puts "Location Memory: #{temp.location_memory}"
      puts "Cylinder Location: #{temp.cylinder_num}" if "#{device}" == "disk"
      is_write = temp.read_or_write 
      puts "Read Or Write: #{temp.read_or_write}"
      puts "Size of file: #{temp.size_of_file}" if is_write == 'w'
      puts "The time spent on CPU is: #{temp.time_spent_in_cpu}"
      puts "The average burst time is #{temp.compute_average_burst_time}" 
      @queue << temp
    end
  end

  def device
    "device"
  end
end

class Printer < Device
  def device
    "printer"
  end
end

class Disk < Device
  attr_accessor :num_of_cylinders
  def initialize
    super
    @num_of_cylinders = 0
  end

  def set_num_of_cylinders(num)
    @num_of_cylinders = num
  end

  def device
    "disk"
  end
end 

class Rewriteable < Device
  def device
    "rewriteable"
  end
end 