# Experimental
class Rfm::Resultset
  def to_yaml
    self.to_a.to_yaml
  end
end