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

    puts "Welcome to your OS"
    
    puts "How many printers do you want to insert?"
    @num_printers = gets.chomp
    @num_printers = gets.chomp while (check_if_integer(@num_printers) == false)

    puts "How many disks do you want to insert?"
    @num_disks = gets.chomp
    @num_disks = gets.chomp while (check_if_integer(@num_disks) == false)
    
    puts "How many rewriteables do you want to insert?"
    @num_rewriteables = gets.chomp
    @num_rewriteables = gets.chomp while (check_if_integer(@num_rewriteables) == false)

    abort("you created no devices, please start the program again") if (check_if_all_are_zeros(@num_printers.to_i, @num_rewriteables.to_i, @num_disks.to_i) == 0)
    abort("you created negative devices, please start the program again") if (@num_printers.to_i < 0 || @num_disks.to_i < 0 || @num_rewriteables.to_i < 0)

    generate_printers(@num_printers.to_i)
    generate_disks(@num_disks.to_i)
    generate_rewriteables(@num_rewriteables.to_i)
  end

  def initiate_commands
    while true
      puts "Enter a command (type 'quit' to shut down):  "
      @command = gets.chomp
      @command = gets.chomp while (check_if_proper_input(@command) == false)
      arrival_of_process if @command == 'A'
      snapshot_mode if @command == 'S'
      terminate_process if @command == 't'
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
    @pcb_to_terminate = @os_cpu.dequeue_pcb if @os_cpu.get_cpu_length > 0
    puts "You've successfully terminated pcb with p_id #{@pcb_to_terminate.p_id}"
    @os_cpu.insert_to_cpu(@os_ready_queue.dequeue_pcb) if @os_ready_queue.get_ready_queue_length > 0
  end

  private

  def generate_printers(num)
    @printers = Array.new
    num.times{ @printers << Printer.new }
  end

  def generate_disks(num)
    @disks = Array.new
    num.times{ @disks << Disk.new } 
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
      @new_printer_pcb = @os_cpu.dequeue_pcb if @os_cpu.get_cpu_length > 0 # getting pcb from cpu
      @new_printer_pcb.passed_to_device_queue_is_printer
      @os_cpu.insert_to_cpu(@os_ready_queue.dequeue_pcb) if @os_ready_queue.get_ready_queue_length > 0
      @printers[num-1].enqueue_device(@new_printer_pcb)
      puts "Number of pcb's in printer #{num} queue is: #{@printers[num-1].number_of_pcb_in_device}"
    elsif device != 'd' and device != 'c' #could prob handle this better
      puts "You did not create that many printers"
    else
    end

    if device == 'd' and num != 0 and num <= @disks.length
      @new_disk_pcb = @os_cpu.dequeue_pcb if @os_cpu.get_cpu_length > 0 # getting pcb from cpu
      @new_disk_pcb.passed_to_device_queue
      @os_cpu.insert_to_cpu(@os_ready_queue.dequeue_pcb) if @os_ready_queue.get_ready_queue_length > 0
      @disks[num-1].enqueue_device(@new_disk_pcb)
      puts "Number of pcb's in disks #{num} queue is: #{@disks[num-1].number_of_pcb_in_device}"
    elsif device != 'p' and device != 'c' #could prob handle this better
      puts "You did not create that many disks"
    else
    end

    if device == 'c' and num != 0 and num <= @rewriteables.length
      @new_rewriteable_pcb = @os_cpu.dequeue_pcb if @os_cpu.get_cpu_length > 0 # getting pcb from cpu
      @new_rewriteable_pcb.passed_to_device_queue
      @os_cpu.insert_to_cpu(@os_ready_queue.dequeue_pcb) if @os_ready_queue.get_ready_queue_length > 0
      @rewriteables[num-1].enqueue_device(@new_rewriteable_pcb)
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
      @os_cpu.get_cpu_length == 0 ? @os_cpu.insert_to_cpu(@printer_pcb_completed) : @os_ready_queue.enqueue_pcb(@printer_pcb_completed)
      puts "You've moved printer #{num} PCB with p_id: #{@printer_pcb_completed.p_id} from the device queue to the ReadyQueue (or possibly CPU)" 
    end

    if device == 'D'
      return puts "This disk does not exist" if @disks.size < num
      return puts "there are no pcb's on disk's #{num} queue" if @disks[num-1].number_of_pcb_in_device == 0 
      @disk_pcb_completed = @disks[num-1].dequeue_device
      @os_cpu.get_cpu_length == 0 ? @os_cpu.insert_to_cpu(@disk_pcb_completed) : @os_ready_queue.enqueue_pcb(@disk_pcb_completed)
      puts "You've moved disk #{num} PCB with p_id: #{@disk_pcb_completed.p_id} from the device queue to the ReadyQueue (or possibly CPU)"
    end
    
    if device == 'C'
      return puts "This rewriteable does not exist" if @rewriteables.size < num
      return puts "there are no pcb's on rewriteable's #{num} queue" if @rewriteables[num-1].number_of_pcb_in_device == 0 
      @rewriteable_pcb_completed = @rewriteables[num-1].dequeue_device
      @os_cpu.get_cpu_length == 0 ? @os_cpu.insert_to_cpu(@rewriteable_pcb_completed) : @os_ready_queue.enqueue_pcb(@rewriteable_pcb_completed)
      puts "You've moved rewriteable #{num} PCB with p_id: #{@rewriteable_pcb_completed.p_id} from the device queue to the ReadyQueue (or possibly CPU)"
    end
  end
  
  def show_pids_processes_in_ready_queue
    @os_cpu.view_cpu
    @os_ready_queue.view_ready_queue
  end

  def show_pids_and_printer_device_queue_info
    i = 0
    @printers.each do |printer|
      i = i + 1 
      printer.view_device(i) 
    end
  end

  def show_pids_and_disk_device_queue_info
    i = 0
    @disks.each do |disk| 
      i = i + 1
      disk.view_device(i)
    end
  end  

  def show_pids_and_rewriteable_device_queue_info
    i = 0 
    @rewriteables.each do |rewriteable| 
      i = i + 1
      rewriteable.view_device(i)
    end
  end
end 

