module OpenNlp
  class Tool
    include JavaClass

    attr_reader :j_instance

    def initialize(model)
      raise ArgumentError, "model must be an OpenNlp::Model" unless model.is_a?(OpenNlp::Model)
      @j_instance = self.class.java_class.new(model.j_model)
    end
  end
end