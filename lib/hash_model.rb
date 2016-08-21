class HashModel
  def initialize(attributes={})
    attributes.each do |k, v|
      assign_attribute(k, v)
    end
  end

  def assign_attribute(k, v)
    if respond_to?("#{k}=")
      public_send("#{k}=", v)
    else
      raise UnknownAttributeError.new(self, k)
    end
  end
end
