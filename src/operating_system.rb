require './helpers'
require 'thread'
require './pcb'
require './ready_queue'
require './cpu'

class Os
  include Helpers

  def initialize
    @os_ready_queue = ReadyQueue.new
    @os_cpu = Cpu.new
    @p_id = -1
    @total_time_processes_spent_on_cpu = 0
    @total_number_of_bursts = 0


    puts "Welcome to your OS"
    
    puts "How many printers do you want to insert?"
    @num_printers = gets.chomp
    @num_printers = gets.chomp while (check_if_integer(@num_printers) == false)
    generate_printers(@num_printers.to_i)

    puts "How many disks do you want to insert?"
    @num_disks = gets.chomp
    @num_disks = gets.chomp while (check_if_integer(@num_disks) == false)
    generate_disks(@num_disks.to_i)
    
    puts "How many rewriteables do you want to insert?"
    @num_rewriteables = gets.chomp
    @num_rewriteables = gets.chomp while (check_if_integer(@num_rewriteables) == false)
    generate_rewriteables(@num_rewriteables.to_i)

    puts "What is the length of a time slice (in milliseconds)?"
    @time_slice = gets.chomp
    @time_slice = gets.chomp while (check_if_integer(@time_slice) == false)

    abort("you created no devices, please start the program again") if (check_if_all_are_zeros(@num_printers.to_i, @num_rewriteables.to_i, @num_disks.to_i) == 0)
    abort("you created negative devices, please start the program again") if (@num_printers.to_i < 0 || @num_disks.to_i < 0 || @num_rewriteables.to_i < 0)
  end

  def initiate_commands
    while true
      puts "Enter a command ('A' => PCB, 'S' => Snapshot, 't' => Terminate, 'T' => Time Slice, 'quit' => shut down):  "
      @command = gets.chomp
      @command = gets.chomp while (check_if_proper_input(@command) == false)
      arrival_of_process if @command == 'A'
      snapshot_mode if @command == 'S'
      terminate_process if @command == 't'
      time_slice_ends if @command == 'T'
      handle_system_request(@command) if /[pcdPCD]/.match(@command[0])
      abort("Shut Down.") if @command == "quit"
    end
  end

  def snapshot_mode
    puts "Snapshot Mode"
    puts "These are the options you have: r,p,d and c"
    @snapshot_mode_command = gets.chomp
    @snapshot_mode_command = gets.chomp while (check_if_proper_input_for_snapshot_mode(@snapshot_mode_command) == false)
    show_pids_processes_in_ready_queue if @snapshot_mode_command == 'r'
    show_pids_and_printer_device_queue_info if @snapshot_mode_command == 'p'
    show_pids_and_disk_device_queue_info if @snapshot_mode_command == 'd'
    show_pids_and_rewriteable_device_queue_info if @snapshot_mode_command == 'c'
  end

  def arrival_of_process
    @p_id = @p_id + 1
    new_pcb = Pcb.new(@p_id)
    @os_ready_queue.enqueue_pcb(new_pcb)
    @os_cpu.insert_to_cpu(@os_ready_queue.dequeue_pcb) if @os_cpu.get_cpu_length == 0
    puts "the number of pcb's in the Ready Queue #{@os_ready_queue.get_ready_queue_length}"
    puts "the number of pcb's in the CPU: #{@os_cpu.get_cpu_length}"
  end

  def terminate_process
    return puts "Nothing to terminate, CPU empty" if @os_cpu.get_cpu_length == 0
    pcb_to_terminate = @os_cpu.dequeue_pcb if @os_cpu.get_cpu_length > 0
    puts "How long was this PCB in the CPU just now?"
    time_spent = gets.chomp
    time_spent = gets.chomp while(check_if_num_is_less_than_time_slice(@time_slice.to_i, time_spent.to_i) == false)
    pcb_to_terminate.time_spent_in_cpu += time_spent.to_i
    @total_time_processes_spent_on_cpu += pcb_to_terminate.time_spent_in_cpu # update the total global cpu time
    @total_number_of_bursts += 1 # update the total global burst occurences
    puts "You've successfully terminated pcb with p_id #{pcb_to_terminate.p_id}"
    puts "The total time CPU time is #{pcb_to_terminate.time_spent_in_cpu}"
    @os_cpu.insert_to_cpu(@os_ready_queue.dequeue_pcb) if @os_ready_queue.get_ready_queue_length > 0
  end

  private

  def generate_printers(num)
    @printers = Array.new
    num.times{ @printers << Printer.new }
  end

  def generate_disks(num)
    # TODO: find a better way to keep track of the # of iterations
    i = 1 
    @disks = Array.new
    num.times do |disk|
      disk = Disk.new
      puts "Enter the number of cylinders disk #{i} has: "
      num_of_cylinders = gets.chomp
      num_of_cylinders = gets.chomp while (check_if_integer(num_of_cylinders) == false)
      disk.set_num_of_cylinders(num_of_cylinders.to_i)
      @disks << disk
      i += 1
    end
  end

  def generate_rewriteables(num)
    @rewriteables = Array.new
    num.times{ @rewriteables << Rewriteable.new }
  end

  def handle_system_request(param)
    @request = param.partition(/[pcd]/i).reject!{ |c| c.empty? }
    system_call(@request[0], @request[1].to_i) if check_if_its_upper(@request[0]) == false
    signal_completion(@request[0], @request[1].to_i) if check_if_its_upper(@request[0]) == true
  end

  def system_call(device, num)
    if @os_ready_queue.get_ready_queue_length == 0 and @os_cpu.get_cpu_length == 0
      puts "There are no PCB's available, please create some"
      return
    end

    if device == 'p' and num != 0 and num <= @printers.length
      new_printer_pcb = @os_cpu.dequeue_pcb if @os_cpu.get_cpu_length > 0 # getting pcb from cpu
      puts "How long was this PCB in the CPU?"
      time_spent = gets.chomp
      time_spent = gets.chomp while(check_if_num_is_less_than_time_slice(@time_slice.to_i, time_spent.to_i) == false)
      new_printer_pcb.time_spent_in_cpu += time_spent.to_i
      new_printer_pcb.burst_occurs # burst occurs here
      @total_time_processes_spent_on_cpu += new_printer_pcb.time_spent_in_cpu # update the total global cpu time
      @total_number_of_bursts += 1 # update the total global burst occurences
      new_printer_pcb.passed_to_device_queue_is_printer
      @os_cpu.insert_to_cpu(@os_ready_queue.dequeue_pcb) if @os_ready_queue.get_ready_queue_length > 0
      @printers[num-1].enqueue_device(new_printer_pcb)
      puts "Number of pcb's in printer #{num} queue is: #{@printers[num-1].number_of_pcb_in_device}"
    elsif device != 'd' and device != 'c' #could prob handle this better
      puts "You did not create that many printers"
    else
    end

    if device == 'd' and num != 0 and num <= @disks.length
      new_disk_pcb = @os_cpu.dequeue_pcb if @os_cpu.get_cpu_length > 0 # getting pcb from cpu
      puts "How long was this PCB in the CPU?"
      time_spent = gets.chomp
      time_spent = gets.chomp while(check_if_num_is_less_than_time_slice(@time_slice.to_i, time_spent.to_i) == false)
      new_disk_pcb.time_spent_in_cpu += time_spent.to_i
      new_disk_pcb.burst_occurs # burst occurs here
      @total_time_processes_spent_on_cpu += new_disk_pcb.time_spent_in_cpu # update the total global cpu time
      @total_number_of_bursts += 1 # update the total global burst occurences
      new_disk_pcb.passed_to_device_queue_is_disk(@disks[num-1].num_of_cylinders)
      @os_cpu.insert_to_cpu(@os_ready_queue.dequeue_pcb) if @os_ready_queue.get_ready_queue_length > 0
      @disks[num-1].enqueue_device(new_disk_pcb)
      puts "Number of pcb's in disks #{num} queue is: #{@disks[num-1].number_of_pcb_in_device}"
    elsif device != 'p' and device != 'c' #could prob handle this better
      puts "You did not create that many disks"
    else
    end

    if device == 'c' and num != 0 and num <= @rewriteables.length
      new_rewriteable_pcb = @os_cpu.dequeue_pcb if @os_cpu.get_cpu_length > 0 # getting pcb from cpu
      puts "How long was this PCB in the CPU?"
      time_spent = gets.chomp
      time_spent = gets.chomp while(check_if_num_is_less_than_time_slice(@time_slice.to_i, time_spent.to_i) == false)
      new_rewriteable_pcb.time_spent_in_cpu += time_spent.to_i
      new_rewriteable_pcb.burst_occurs # burst occurs here
      @total_time_processes_spent_on_cpu += new_rewriteable_pcb.time_spent_in_cpu # update the total global cpu time
      @total_number_of_bursts += 1
      new_rewriteable_pcb.passed_to_device_queue
      @os_cpu.insert_to_cpu(@os_ready_queue.dequeue_pcb) if @os_ready_queue.get_ready_queue_length > 0
      @rewriteables[num-1].enqueue_device(new_rewriteable_pcb)
      puts "Number of pcb's in rewriteables #{num} queue is: #{@rewriteables[num-1].number_of_pcb_in_device}"
    elsif device != 'p' and device != 'd' #could prob handle this better
      puts "You did not create that many rewriteables"
    else
    end
  end

  def signal_completion(device, num)
    if device == 'P'
      return puts "This printer does not exist" if @printers.size < num
      return puts "there are no pcb's on printer's #{num} queue" if @printers[num-1].number_of_pcb_in_device == 0 
      @printer_pcb_completed = @printers[num-1].dequeue_device
      @printer_pcb_completed.time_spent_in_cpu = 0 # reset the time spent in CPU
      @os_cpu.get_cpu_length == 0 ? @os_cpu.insert_to_cpu(@printer_pcb_completed) : @os_ready_queue.enqueue_pcb(@printer_pcb_completed)
      puts "You've moved printer #{num} PCB with p_id: #{@printer_pcb_completed.p_id} from the device queue to the ReadyQueue (or possibly CPU)" 
    end

    if device == 'D'
      return puts "This disk does not exist" if @disks.size < num
      return puts "there are no pcb's on disk's #{num} queue" if @disks[num-1].number_of_pcb_in_device == 0
      @disk_pcb_completed = @disks[num-1].dequeue_device
      @disk_pcb_completed.time_spent_in_cpu = 0
      @os_cpu.get_cpu_length == 0 ? @os_cpu.insert_to_cpu(@disk_pcb_completed) : @os_ready_queue.enqueue_pcb(@disk_pcb_completed)
      puts "You've moved disk #{num} PCB with p_id: #{@disk_pcb_completed.p_id} and cylinder location #{@disk_pcb_completed.cylinder_num} from the device queue to the ReadyQueue (or possibly CPU)"
    end
    
    if device == 'C'
      return puts "This rewriteable does not exist" if @rewriteables.size < num
      return puts "there are no pcb's on rewriteable's #{num} queue" if @rewriteables[num-1].number_of_pcb_in_device == 0 
      @rewriteable_pcb_completed = @rewriteables[num-1].dequeue_device
      @rewriteable_pcb_completed.time_spent_in_cpu = 0
      @os_cpu.get_cpu_length == 0 ? @os_cpu.insert_to_cpu(@rewriteable_pcb_completed) : @os_ready_queue.enqueue_pcb(@rewriteable_pcb_completed)
      puts "You've moved rewriteable #{num} PCB with p_id: #{@rewriteable_pcb_completed.p_id} from the device queue to the ReadyQueue (or possibly CPU)"
    end
  end
  def time_slice_ends
    return puts "Can't operate a time slice, CPU empty" if @os_cpu.get_cpu_length == 0
    pcb = @os_cpu.dequeue_pcb
    pcb.time_spent_in_cpu += @time_slice.to_i # update the time slice
    @total_time_processes_spent_on_cpu += pcb.time_spent_in_cpu
    @os_ready_queue.enqueue_pcb(pcb)
    @os_cpu.insert_to_cpu(@os_ready_queue.dequeue_pcb) if @os_cpu.get_cpu_length == 0
  end
  
  def show_pids_processes_in_ready_queue
    @os_cpu.view_cpu
    @os_ready_queue.view_ready_queue
    if @total_number_of_bursts != 0
      puts "The System's average total CPU Time is #{@total_time_processes_spent_on_cpu/@total_number_of_bursts}"
      puts "Total time of CPU usage: #{@total_time_processes_spent_on_cpu} | Total number of bursts #{@total_number_of_bursts}"
    end
  end

  def show_pids_and_printer_device_queue_info
    @printers.each_with_index do |printer, i|
      printer.view_device(i+1) 
    end
    if @total_number_of_bursts != 0
      puts "The System's average total CPU Time is #{@total_time_processes_spent_on_cpu/@total_number_of_bursts}"
      puts "Total time of CPU usage: #{@total_time_processes_spent_on_cpu} | Total number of bursts #{@total_number_of_bursts}"
    end
  end

  def show_pids_and_disk_device_queue_info
    @disks.each_with_index do |disk, i| 
      disk.view_device(i+1)
    end
    if @total_number_of_bursts != 0
      puts "The System's average total CPU Time is #{@total_time_processes_spent_on_cpu/@total_number_of_bursts}"
      puts "Total time of CPU usage: #{@total_time_processes_spent_on_cpu} | Total number of bursts #{@total_number_of_bursts}"
    end
  end  

  def show_pids_and_rewriteable_device_queue_info
    @rewriteables.each_with_index do |rewriteable, i| 
      rewriteable.view_device(i+1)
    end
    if @total_number_of_bursts != 0
      puts "The System's average total CPU Time is #{@total_time_processes_spent_on_cpu/@total_number_of_bursts}"
      puts "Total time of CPU usage: #{@total_time_processes_spent_on_cpu} | Total number of bursts #{@total_number_of_bursts}"
    end
  end
end 

