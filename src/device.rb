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

  def dequeue_device
    @queue.pop
  end

  def number_of_pcb_in_device
    @queue.length
  end

  def view_device(i)
    # Professor does not want this content to exceed 23 lines
    # The max a device will print is 5 lines (if it's a write file)
    # Therefore it should not print out more than 4 iterations
    return puts "#{device}'s #{i} queue is empty" if @queue.empty?
    if @queue.length > 4
      puts "To fully see all of the PCB's in the #{device}'s queue, it will exceed 23 lines" 
      puts "Do you wish to see all (will exceeed 23 lines), or will you rather just see enough to fit 23 lines? (yes/no)"
      @exceeed_or_not = gets.chomp
      @exceeed_or_not = gets.chomp while (check_if_yes_or_no(@exceeed_or_not) == false)
      if @exceeed_or_not == 'yes'
        @times_to_iterate = @queue.length
      else 
        @times_to_iterate = 4
      end
    else
      @times_to_iterate = @queue.length
    end

    

    @times_to_iterate.times do
      temp = @queue.pop
      puts "PCB with p_id: #{temp.p_id} is in #{device} #{i}"
      puts "File: #{temp.file_name}"
      puts "Location Memory: #{temp.location_memory}"
      is_write = temp.read_or_write 
      puts "Read Or Write: #{temp.read_or_write}"
      puts "Size of file: #{temp.size_of_file}" if is_write == 'w'
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
  def device
    "disk"
  end
end 

class Rewriteable < Device
  def device
    "rewriteable"
  end
end 