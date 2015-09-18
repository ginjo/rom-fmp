require 'rfm'

class Rfm::Layout
  # Strip out unnecessary output in Rfm::Layout#inspect
  def inspect
    "#<#{self.class.name}:#{self.object_id} @name=#{self.name} @database=#{database.name} @server=#{server.host_name} @loaded=#{@loaded}>"
  end
end