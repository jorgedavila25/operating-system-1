require 'thread'

class Cpu
  attr_accessor :queue

  def initialize
    @queue = Queue.new
  end

  def insert_to_cpu(pcb)
    @queue << pcb
  end

  def dequeue_pcb
    @queue.pop 
  end

  def get_cpu_length
    @queue.length
  end

end