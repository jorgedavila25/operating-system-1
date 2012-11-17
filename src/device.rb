require 'thread'
require './helpers'

class Device
  include Helpers
  
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
  #  device  | p_id  | file_name  |  R/W  |  Size  |  CPU Time  |  Avg Burst Time  
  #  ============================================================================
  def view_device(i)
    return puts "#{device}'s #{i} queue is empty" if @queue.empty?
    # TODO Make sure printing devices do not exceed 23 lines
    @queue.length.times do
      temp = @queue.pop
      puts "PCB with p_id: #{temp.p_id} is in #{device} #{i}"
      puts "File: #{temp.file_name}"
      puts "Location Memory: #{temp.location_memory}"
      puts "Cylinder Location: #{temp.cylinder_num}" if "#{device}" == "disk"
      is_write = temp.read_or_write 
      puts "Read Or Write: #{temp.read_or_write}"
      puts "Size of file: #{temp.size_of_file}" if is_write == 'w'
      puts "The time spent on CPU is: #{temp.time_spent_in_cpu}"
      puts "The average burst time is #{temp.compute_average_burst_time}" 
      @queue << temp
    end
  end

  def device
    "device"
  end
end

class Printer < Device
  def device
    "printer"
  end
end

class Disk < Device
  attr_accessor :num_of_cylinders

  def initialize
    @processes_in_queue = Array.new
    @new_array = Array.new
    @once = 0
    @red_light = 0
    @num_of_cylinders = 0
  end

  def enqueue_device(pcb)
    if @red_light == 0
      @processes_in_queue << pcb
    elsif @red_light == 1
      puts "ENQUEIN NEW ARRAY"
      @new_array << pcb
    end
  end

  def dequeue_device
    c_look_alogrithm
  end

  def c_look_alogrithm  
    # first time through, to get the disk head started
    if @once == 0 
      puts "should be output once"
      @once = 1
      @processes_in_queue.sort_by!{|obj| obj.cylinder_num} # sort by the cylinder num
      @head = @processes_in_queue[0].cylinder_num # save the current num you're about to return
      return @processes_in_queue.shift # pop off process
    end

    if @red_light == 0
      temp_array = @processes_in_queue.select { |x| x.cylinder_num < @head }
      @new_array += temp_array
      @processes_in_queue.delete_if {|x| x.cylinder_num < @head }
    elsif @red_light == 1
      @processes_in_queue = @new_array.select { |x| x.cylinder_num < @head } 
      @new_array.delete_if {|x| x.cylinder_num < @head }
    end

    if @processes_in_queue.size > 0 and @red_light == 0
      @processes_in_queue.sort_by!{|obj| obj.cylinder_num} # sort by the cylinder num
      @head = @processes_in_queue[0].cylinder_num # save the current num you're about to return
      return @processes_in_queue.shift # pop off process
    elsif @new_array.size > 0 
      @red_light = 1
      @new_array.sort_by! {|obj| obj.cylinder_num} # sort by the cylinder num
      @head = @new_array[0].cylinder_num # save the current num you're about to return
      return @new_array.shift # pop off process
    else
      puts "empty"
    end
  end

  def set_num_of_cylinders(num)
    @num_of_cylinders = num
  end

  def number_of_pcb_in_device
    @red_light = 0 if (@processes_in_queue.length + @new_array.length) == 0
    @processes_in_queue.length + @new_array.length
  end

  def view_device(i)
    return puts "#{device}'s #{i} queue is empty" if @processes_in_queue.empty? and @new_array.empty?
    # TODO Make sure printing devices do not exceed 23 lines
    if @red_light == 0
      @processes_in_queue.each do |temp|
        puts "PCB with p_id: #{temp.p_id} is in #{device} #{i}"
        puts "File: #{temp.file_name}"
        puts "Location Memory: #{temp.location_memory}"
        puts "Cylinder Location: #{temp.cylinder_num}" if "#{device}" == "disk"
        is_write = temp.read_or_write 
        puts "Read Or Write: #{temp.read_or_write}"
        puts "Size of file: #{temp.size_of_file}" if is_write == 'w'
        puts "The time spent on CPU is: #{temp.time_spent_in_cpu}"
        puts "The average burst time is #{temp.compute_average_burst_time}"
      end
      @new_array.each do |temp|
        puts "PCB with p_id: #{temp.p_id} is in #{device} #{i}"
        puts "File: #{temp.file_name}"
        puts "Location Memory: #{temp.location_memory}"
        puts "Cylinder Location: #{temp.cylinder_num}" if "#{device}" == "disk"
        is_write = temp.read_or_write 
        puts "Read Or Write: #{temp.read_or_write}"
        puts "Size of file: #{temp.size_of_file}" if is_write == 'w'
        puts "The time spent on CPU is: #{temp.time_spent_in_cpu}"
        puts "The average burst time is #{temp.compute_average_burst_time}"
      end
    elsif @red_light == 1
      @new_array.each do |temp|
        puts "PCB with p_id: #{temp.p_id} is in #{device} #{i}"
        puts "File: #{temp.file_name}"
        puts "Location Memory: #{temp.location_memory}"
        puts "Cylinder Location: #{temp.cylinder_num}" if "#{device}" == "disk"
        is_write = temp.read_or_write 
        puts "Read Or Write: #{temp.read_or_write}"
        puts "Size of file: #{temp.size_of_file}" if is_write == 'w'
        puts "The time spent on CPU is: #{temp.time_spent_in_cpu}"
        puts "The average burst time is #{temp.compute_average_burst_time}"
      end
      @processes_in_queue.each do |temp|
        puts "PCB with p_id: #{temp.p_id} is in #{device} #{i}"
        puts "File: #{temp.file_name}"
        puts "Location Memory: #{temp.location_memory}"
        puts "Cylinder Location: #{temp.cylinder_num}" if "#{device}" == "disk"
        is_write = temp.read_or_write 
        puts "Read Or Write: #{temp.read_or_write}"
        puts "Size of file: #{temp.size_of_file}" if is_write == 'w'
        puts "The time spent on CPU is: #{temp.time_spent_in_cpu}"
        puts "The average burst time is #{temp.compute_average_burst_time}"
      end
    end
  end

  def device
    "disk"
  end
end 

class Rewriteable < Device
  def device
    "rewriteable"
  end
end 