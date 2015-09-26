# Experimental: NONE OF THESE WORK !?
class Rfm::Resultset
  def to_yaml(options={})
    self.to_a.to_yaml(:nodump=>false)
  end
  
  def to_yaml_properties
    self.to_a.to_yaml_properties
  end
end