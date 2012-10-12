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
end

class Printer < Device
  def enqueue_to_printer(pcb)
    @queue << pcb
  end

  def dequeue_printer

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