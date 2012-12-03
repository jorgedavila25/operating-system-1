require 'thread'

class JobPool

  def initialize
    @queue = Array.new
  end

  def enqueue_pcb(arg)
    @queue << arg
  end

  def view_ready_queue
    return puts "Job Queue is empty" if @queue.empty?
    @queue.each do |temp|
      puts "PCB with p_id: #{temp.p_id} is in the Job Pool. Total time it's used the CPU is #{temp.time_spent_in_cpu}"
    end
  end

  def dequeue_pcb
    @queue.shift
  end

  def get_ready_queue_length
    @queue.length
  end
end
