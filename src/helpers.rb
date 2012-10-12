module Helpers

  def check_if_integer(candidate)
    begin
        @location_memory = Integer(candidate)
        return true
    rescue ArgumentError
        puts "Please enter a valid integer, try again"
        return false
    end      
  end

  def check_if_its_upper(candidate)
    return true if /[[:upper:]]/.match(candidate)
    false
  end

  def check_if_proper_input(arg)
    return true if arg == "quit"
    return true if /^[AtS]{1}$|^[pdcPDC]\d+$/.match(arg)
    puts "Please enter a proper input"
    return false
  end
  
  def check_if_proper_input_for_snapshot_mode(arg)
    return true if /^[rpdc]{1}$/.match(arg) 
    puts "Please enter a proper command for snapshot mode"
    return false
  end

  def check_if_read_or_write(candidate)
    return true if (candidate == "r" || candidate == "w")
    puts "Please enter r or w"
    return false
  end

  def check_if_yes_or_no(candidate)
    return true if (candidate == "yes" || candidate == "no")
    puts "Please enter yes or not"
    return false
  end

  def check_if_all_are_zeros(*args)
    args.inject{|sum,x| sum + x }
  end
end 
