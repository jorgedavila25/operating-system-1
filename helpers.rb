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

  def check_if_proper_input(arg)
     return true if /^[AtSrpdc]{1}$|^[pdcPDC]\d+$/.match(arg)
     puts "Please enter a proper input"
     return false
  end

end 
