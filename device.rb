require 'thread'

class Device
  attr_accessor :queue
  
  def initialize
    @queue = Queue.new
  end
end

class Printer < Device
  def enqueue_to_printer(pcb)
    @queue << pcb
  end

  def number_of_pcb_in_printer
    @queue.length
  end
end

class Disk < Device
  def enqueue_to_disk(pcb)
    @queue << pcb
  end

  def number_of_pcb_in_disk
    @queue.length
  end
end 

class Rewriteable < Device
  def enqueue_to_rewriteable(pcb)
    @queue << pcb
  end

  def number_of_pcb_in_rewriteable
    @queue.length
  end
end 