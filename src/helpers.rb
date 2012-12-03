module Helpers

  def check_if_integer(candidate)
    begin
        h = Integer(candidate)
        return true
    rescue ArgumentError
        puts "Please enter a valid integer, try again"
        return false
    end
  end

  def check_power_of_two(candidate)
    if !(candidate.to_s(2).scan(/1/).size == 1)
      puts "Enter a number with power of 2"
      return false
    end
    true
  end

  def check_if_in_cylinder_bounds(candidate, bounds)
    return false if check_if_integer(candidate) == false
    if 0 <= candidate.to_i && candidate.to_i <= bounds-1
      return true
    else
      puts "The number you entered is not in bounds. Please enter a number in between 0 and #{bounds-1}"
      return false
    end
  end

  def check_if_its_upper(candidate)
    return true if /[[:upper:]]/.match(candidate)
    false
  end

  def check_if_proper_input(arg)
    return true if arg == "quit"
    return true if /^[AtST]{1}$|^[pdcPDC]\d+$/.match(arg)
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

  def check_if_pcb_size_is_greater_than_memory(total_memory, candidate)
    candidate > total_memory ? true : false
  end

  def check_if_yes_or_no(candidate)
    return true if (candidate == "yes" || candidate == "no")
    puts "Please enter yes or not"
    return false
  end

  def check_if_all_are_zeros(*args)
    args.inject{|sum,x| sum + x }
  end

  def compute_number_of_pages(total_memory, page_size)
    total_memory/page_size
  end

  def check_if_num_is_less_than_time_slice(time_slice, candidate)
    return false if check_if_integer(candidate) == false
    return true if (candidate < time_slice and candidate > 0 )
    puts "Please enter a number greater than 0 but less than #{time_slice}"
    return false
  end
end
