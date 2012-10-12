require 'thread'

class Device
  attr_accessor :queue
  
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

  def view_device
    @queue.length.times do
      temp = @queue.pop
      puts "PCB with p_id: #{temp.p_id} is in the #{device}"
      puts "File: #{temp.file_name}"
      puts "Location Memory: #{temp.location_memory}"
      puts "Read Or Write: #{temp.read_or_write}"
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