class Object
  def try(method)
    self.nil? ? nil : self.send(method)
  end
end
