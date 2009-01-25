class Object
  def try(*methods)
    #self.nil? ? nil : self.send(method)
    methods.inject(self) do |obj, method|
     obj.nil? ? nil : obj.send(method) 
    end
  end
end
