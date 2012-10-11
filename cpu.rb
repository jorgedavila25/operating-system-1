require 'thread'

class Cpu
  attr_accessor :queue

  def initialize
    @queue = Queue.new
  end

  def insert_to_cpu(pcb)
    @queue.push(pcb)
  end

  def get_ready_cpu_length
    @queue.length
  end

end