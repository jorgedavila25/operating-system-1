require 'thread'

class Cpu
  attr_accessor :queue

  def initialize
    @queue = Queue.new
  end

  def insert_to_cpu(pcb)
    @queue.push(pcb)
  end

  def length_of_cpu
    puts @queue.length
  end

end