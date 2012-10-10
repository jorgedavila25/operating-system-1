require 'thread'

class Device
  attr_accessor :queue
  
  def initialize
    @queue = Queue.new
    puts "hi, I'm a #{base}"
  end
  
  def base
    "base class"
  end

end

class Printer < Device

  def base
    "printer"
  end

end

class Disk < Device
  
  def base
    "Disk"
  end

end 

class Rewriteable < Device
  
  def base
    "Rewriteable"
  end

end 