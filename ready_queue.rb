require 'thread'

class ReadyQueue
  attr_accessor :queue

  def initialize
    @queue = Queue.new
  end

  def enqueue_pcb(arg)
    puts "made it in  ready queue"
    @queue << arg
  end

  def iterate
    puts @queue.length
    @queue.length.times do
      temp = @queue.pop
      puts temp.class
      @queue << temp
    end
  end

  def dequeue_pcb
    @queue.pop
  end

  def get_ready_queue_length
    @queue.length
  end

end