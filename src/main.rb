require './cpu'
require './pcb'
require './operating_system'
require './ready_queue'
require './device'
require './page'
require 'thread'

new_os = Os.new
new_os.initiate_commands

