require 'thread'

class ReadyQueue
  attr_accessor :queue

  def initialize
    @queue = Queue.new
  end

  def enqueue_pcb(arg)
    puts "made it in  ready queue"
    @queue.push(arg)
  end

  def get_ready_queue_length
    puts "number of pcb's in queue #{@queue.length}"
  end

end