class FrameTable

  def initialize(size)
    @frame_table = Array.new(size)
  end

  def set_frame_table(frame_index, pcb)
    @frame_table[frame_index-1] = pcb
  end

  def view_frame_table
    puts "Frame Table"
    @frame_table.each_with_index do |pcb, index|
      if pcb != nil
        print "Frame: #{index} | PID: #{pcb.p_id} | Page Table: "
        pcb.pages_in_pcb.each {|x| print "#{x.page_id} " }
        puts ""
      else
        puts "Frame: #{index} | PID: Empty | Page Table: Empty"
      end
    end
  end

  def view_free_frame_list(frames_from_os)
    puts "Free Frame List:"
    return puts"everything is occupied" if frames_from_os.empty?
    frames_from_os.each do |page|
      puts "Page: #{page.page_id} is available"
    end
  end

  def update_after_terminating_a_pcb(index)
    @frame_table[index] = nil
  end
end
