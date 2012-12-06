require 'thread'

class ReadyQueue

  def initialize
    @queue = Queue.new
  end

  def enqueue_pcb(arg)
    @queue << arg
  end

  def view_ready_queue
    return puts "Ready Queue is empty" if @queue.empty?
    @queue.length.times do
      temp = @queue.pop
      print "PCB with p_id: #{temp.p_id} is in the ReadyQueue | Total CPU time: #{temp.time_spent_in_cpu} | Pages in Page Table: "
      temp.pages_in_pcb.each {|x| print "#{x.page_id} "}
      puts ""
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
