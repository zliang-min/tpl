# this will cause closed stream error when using Nginx + Passenger 2.5 + Ruby 1.9.1-p243
require 'tempfile'
Tempfile.class_eval do
  def unlink
    # keep this order for thread safeness
    begin
      File.unlink(@tmpname) if File.exist?(@tmpname)
      @@cleanlist.delete(@tmpname)
      @data = @tmpname = nil
      ObjectSpace.undefine_finalizer(self)
    rescue Errno::EACCES
      # ignore
    end
  end
end
