require 'thread'

class ReadyQueue

  def initialize
    @queue = Queue.new
  end

  def enqueue_pcb(arg)
    puts "PCB made it in ready queue"
    @queue << arg
  end

  def view_ready_queue
    @queue.length.times do
      temp = @queue.pop
      puts "PCB with p_id: #{temp.p_id} is in the ReadyQueue"
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