require 'thread'

class Cpu

  def initialize
    @queue = Queue.new
  end

  def insert_to_cpu(pcb)
    # puts "PCB made it to the CPU"
    @queue << pcb
  end

  def dequeue_pcb
    @queue.pop
  end

  def view_cpu
    return puts "cpu is empty" if @queue.empty?
    @queue.length.times do
      temp = @queue.pop
      print "PCB with p_id: #{temp.p_id} is in the CPU | Total CPU time: #{temp.time_spent_in_cpu} | Pages in Page Table: "
      temp.pages_in_pcb.each {|x| print "#{x.page_id} "}
      puts ""
      @queue << temp
    end
  end

  def get_cpu_length
    @queue.length
  end
end
