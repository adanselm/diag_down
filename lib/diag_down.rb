module DiagDown
  VERSION = '0.1.0'
end

begin
  require 'diag_down/interpreter'
rescue
  require_relative 'diag_down/interpreter'
end
