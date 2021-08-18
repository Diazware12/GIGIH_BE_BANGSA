class GeneralController
  def self.checkNil(object)
    return true if object.nil?
    return true if object == ''
    false
  end
end
